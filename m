Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbaGBFGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 01:06:03 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:33425 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbaGBFF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 01:05:59 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 08/14] bpf: add eBPF verifier
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
	<1403913966-4927-9-git-send-email-ast@plumgrid.com>
Date: Wed, 02 Jul 2014 14:05:56 +0900
In-Reply-To: <1403913966-4927-9-git-send-email-ast@plumgrid.com> (Alexei
	Starovoitov's message of "Fri, 27 Jun 2014 17:06:00 -0700")
Message-ID: <87y4wc4aff.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly questions and few nitpicks.. :)

On Fri, 27 Jun 2014 17:06:00 -0700, Alexei Starovoitov wrote:
> +/* types of values:
> + * - stored in an eBPF register
> + * - passed into helper functions as an argument
> + * - returned from helper functions
> + */
> +enum bpf_reg_type {
> +	INVALID_PTR,			/* reg doesn't contain a valid pointer */

I don't think it's a good name.  The INVALID_PTR can be read as it
contains a "pointer" which is invalid.  Maybe INTEGER, NUMBER or
something different can be used.  And I think the struct reg_state->ptr
should be renamed also.


> +	PTR_TO_CTX,			/* reg points to bpf_context */
> +	PTR_TO_MAP,			/* reg points to map element value */
> +	PTR_TO_MAP_CONDITIONAL,		/* points to map element value or NULL */
> +	PTR_TO_STACK,			/* reg == frame_pointer */
> +	PTR_TO_STACK_IMM,		/* reg == frame_pointer + imm */
> +	PTR_TO_STACK_IMM_MAP_KEY,	/* pointer to stack used as map key */
> +	PTR_TO_STACK_IMM_MAP_VALUE,	/* pointer to stack used as map elem */

So, these PTR_TO_STACK_IMM[_*] types are only for function argument,
right?  I guessed it could be used to access memory in general too, but
then I thought it'd make verification complicated..

And I also agree that it'd better splitting reg types and function
argument constraints.


> +	RET_INTEGER,			/* function returns integer */
> +	RET_VOID,			/* function returns void */
> +	CONST_ARG,			/* function expects integer constant argument */
> +	CONST_ARG_MAP_ID,		/* int const argument that is used as map_id */

That means a map id should always be a constant (for verification), right?


> +	/* int const argument indicating number of bytes accessed from stack
> +	 * previous function argument must be ptr_to_stack_imm
> +	 */
> +	CONST_ARG_STACK_IMM_SIZE,
> +};

[SNIP]
> +
> +/* check read/write into map element returned by bpf_table_lookup() */
> +static int check_table_access(struct verifier_env *env, int regno, int off,
> +			      int size)

I guess the "table" is an old name of the "map"?


> +{
> +	struct bpf_map *map;
> +	int map_id = env->cur_state.regs[regno].imm;
> +
> +	_(get_map_info(env, map_id, &map));
> +
> +	if (off < 0 || off + size > map->value_size) {
> +		verbose("invalid access to map_id=%d leaf_size=%d off=%d size=%d\n",
> +			map_id, map->value_size, off, size);
> +		return -EACCES;
> +	}
> +	return 0;
> +}


[SNIP]
> +static int check_mem_access(struct verifier_env *env, int regno, int off,
> +			    int bpf_size, enum bpf_access_type t,
> +			    int value_regno)
> +{
> +	struct verifier_state *state = &env->cur_state;
> +	int size;
> +
> +	_(size = bpf_size_to_bytes(bpf_size));
> +
> +	if (off % size != 0) {
> +		verbose("misaligned access off %d size %d\n", off, size);
> +		return -EACCES;
> +	}
> +
> +	if (state->regs[regno].ptr == PTR_TO_MAP) {
> +		_(check_table_access(env, regno, off, size));
> +		if (t == BPF_READ)
> +			mark_reg_no_ptr(state->regs, value_regno);
> +	} else if (state->regs[regno].ptr == PTR_TO_CTX) {
> +		_(check_ctx_access(env, off, size, t));
> +		if (t == BPF_READ)
> +			mark_reg_no_ptr(state->regs, value_regno);
> +	} else if (state->regs[regno].ptr == PTR_TO_STACK) {
> +		if (off >= 0 || off < -MAX_BPF_STACK) {
> +			verbose("invalid stack off=%d size=%d\n", off, size);
> +			return -EACCES;
> +		}

So memory (stack) access is only allowed for a stack base regsiter and a
constant offset, right?


> +		if (t == BPF_WRITE)
> +			_(check_stack_write(state, off, size, value_regno));
> +		else
> +			_(check_stack_read(state, off, size, value_regno));
> +	} else {
> +		verbose("R%d invalid mem access '%s'\n",
> +			regno, reg_type_str[state->regs[regno].ptr]);
> +		return -EACCES;
> +	}
> +	return 0;
> +}

[SNIP]
> +static int check_call(struct verifier_env *env, int func_id)
> +{
> +	struct verifier_state *state = &env->cur_state;
> +	const struct bpf_func_proto *fn = NULL;
> +	struct reg_state *regs = state->regs;
> +	struct bpf_map *map = NULL;
> +	struct reg_state *reg;
> +	int map_id = -1;
> +	int i;
> +
> +	/* find function prototype */
> +	if (func_id <= 0 || func_id >= __BPF_FUNC_MAX_ID) {
> +		verbose("invalid func %d\n", func_id);
> +		return -EINVAL;
> +	}
> +
> +	if (env->prog->info->ops->get_func_proto)
> +		fn = env->prog->info->ops->get_func_proto(func_id);
> +
> +	if (!fn || (fn->ret_type != RET_INTEGER &&
> +		    fn->ret_type != PTR_TO_MAP_CONDITIONAL &&
> +		    fn->ret_type != RET_VOID)) {
> +		verbose("unknown func %d\n", func_id);
> +		return -EINVAL;
> +	}
> +
> +	/* check args */
> +	_(check_func_arg(env, BPF_REG_1, fn->arg1_type, &map_id, &map));
> +	_(check_func_arg(env, BPF_REG_2, fn->arg2_type, &map_id, &map));
> +	_(check_func_arg(env, BPF_REG_3, fn->arg3_type, &map_id, &map));
> +	_(check_func_arg(env, BPF_REG_4, fn->arg4_type, &map_id, &map));

Missing BPF_REG_5?


> +
> +	/* reset caller saved regs */
> +	for (i = 0; i < CALLER_SAVED_REGS; i++) {
> +		reg = regs + caller_saved[i];
> +		reg->read_ok = false;
> +		reg->ptr = INVALID_PTR;
> +		reg->imm = 0xbadbad;
> +	}
> +
> +	/* update return register */
> +	reg = regs + BPF_REG_0;
> +	if (fn->ret_type == RET_INTEGER) {
> +		reg->read_ok = true;
> +		reg->ptr = INVALID_PTR;
> +	} else if (fn->ret_type != RET_VOID) {
> +		reg->read_ok = true;
> +		reg->ptr = fn->ret_type;
> +		if (fn->ret_type == PTR_TO_MAP_CONDITIONAL)
> +			/*
> +			 * remember map_id, so that check_table_access()
> +			 * can check 'value_size' boundary of memory access
> +			 * to map element returned from bpf_table_lookup()
> +			 */
> +			reg->imm = map_id;
> +	}
> +	return 0;
> +}

[SNIP]
> +#define PEAK_INT() \

s/PEAK/PEEK/ ?

Thanks,
Namhyung


> +	({ \
> +		int _ret; \
> +		if (cur_stack == 0) \
> +			_ret = -1; \
> +		else \
> +			_ret = stack[cur_stack - 1]; \
> +		_ret; \
> +	 })
> +
> +#define POP_INT() \
> +	({ \
> +		int _ret; \
> +		if (cur_stack == 0) \
> +			_ret = -1; \
> +		else \
> +			_ret = stack[--cur_stack]; \
> +		_ret; \
> +	 })
