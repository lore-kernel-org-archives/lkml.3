Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbaDGQlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 12:41:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbaDGQlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 12:41:49 -0400
Date: Mon, 7 Apr 2014 18:41:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 5/6] uprobes/x86: Emulate rip-relative
	conditional "short" jmp's
Message-ID: <20140407164143.GA18185@redhat.com>
References: <20140406201524.GA32694@redhat.com> <20140406201632.GA514@redhat.com> <20140407142723.GA8881@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140407142723.GA8881@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07, Oleg Nesterov wrote:
>
> > Incomplete, lacks "jcxz". Simple to fix. Anything else?
>
> Please see v2 below. Simplify the preprocessor hacks.

Finally some testing. This all even seems to work... Although so far
I only tested jz/jnz 8/32bit with this test-case:

	asm (
		".text\n"
		".globl test_0\n"
		"test_0:\n"

		"movq $0, %rax\n"
		"cmpq $0, %rax\n"

		".globl t_0_n; t_0_n:\n"
		"jnz 1f\n"

		".globl t_0_y; t_0_y:\n"
		"jz  2f\n"

		"1: ud2\n"
		"2: retq\n"
	);

	asm (
		".text\n"
		".globl test_1\n"
		"test_1:\n"

		"movq $1, %rax\n"
		"cmpq $0, %rax\n"

		".globl t_1_y; t_1_y:\n"
		"jz 1f\n"

		".globl t_1_n; t_1_n:\n"
		"jnz  2f\n"

		".org . + 1024\n"

		"1: ud2\n"
		"2: retq\n"
	);

	extern void test_0(void), test_1(void);

	int main(void)
	{
		test_0();
		test_1();
		return 0;
	}

it runs fine with t_{0,1}_{y,} probed.

As for "jcxz" support, it must be simple but I am still googling for
"jcxz for dummies". Will do tomorrow, probably I'll make a separate patch
for this to simlify the review.

Oleg.

