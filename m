Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab3F2DAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 23:00:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14608 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab3F2DAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 23:00:24 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=K-hHAvmzDjYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=lVSx7YhZmtMA:10 a=X7Ea-ya5AAAA:8 a=VPW9pYw8AAAA:8 a=oousBsYe7VwN5ef7N9IA:9 a=QEXdDO2ut3YA:10 a=EMEU_Dz8dBsA:10 a=nTicbzAlsOkA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372474821.18733.344.camel@gandalf.local.home>
Subject: Re: [PATCH 1/3] static_keys: Add a
 static_key_slow_set_true()/false() interface
From: Steven Rostedt <rostedt@goodmis.org>
To: jbaron@akamai.com
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
        peterz@infradead.org
Date: Fri, 28 Jun 2013 23:00:21 -0400
In-Reply-To: <4cd4ed35e383e64af7e482f2d2827703ec943c75.1372457176.git.jbaron@akamai.com>
References: <cover.1372457176.git.jbaron@akamai.com>
	 <4cd4ed35e383e64af7e482f2d2827703ec943c75.1372457176.git.jbaron@akamai.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-28 at 22:30 +0000, jbaron@akamai.com wrote:
> As pointed out by Andi Kleen, some static key users can be racy because they
> check the value of the key->enabled, and then subsequently update the branch
> direction. A number of call sites have 'higher' level locking that avoids this
> race, but the usage in the scheduler features does not. See:
> http://lkml.indiana.edu/hypermail/linux/kernel/1304.2/01655.html
> 
> Thus, introduce a new API that does the check and set under the
> 'jump_label_mutex'. This should also allow to simplify call sites a bit.
> 
> Users of static keys should use either the inc/dec or the set_true/set_false
> API.
> 
> Signed-off-by: Jason Baron <jbaron@akamai.com>
> ---
>  Documentation/static-keys.txt |    8 ++++++++
>  include/linux/jump_label.h    |   30 ++++++++++++++++++++++++++++++
>  kernel/jump_label.c           |   40 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 78 insertions(+)
> 
> diff --git a/Documentation/static-keys.txt b/Documentation/static-keys.txt
> index 9f5263d..4cca941 100644
> --- a/Documentation/static-keys.txt
> +++ b/Documentation/static-keys.txt
> @@ -134,6 +134,14 @@ An example usage in the kernel is the implementation of tracepoints:
>                                  TP_CONDITION(cond));                    \
>          }
>  
> +Keys can also be updated with the following calls:

I would explain this a bit more. Something like:

When dealing with a simple on/off switch, where there's not a usage
counter involved with the static_key, the
static_key_slow_set_true/false() methods should be used.


> +
> +	static_key_slow_set_true(struct static_key *key);
> +	static_key_slow_set_false(struct static_key *key);
> +
> +Users should of the API should not mix the inc/dec with usages
> +of set_true/set_false. That is, users should choose one or the other.

Fix the above comment.

-- Steve


> +
>  Tracepoints are disabled by default, and can be placed in performance critical
>  pieces of the kernel. Thus, by using a static key, the tracepoints can have
>  absolutely minimal impact when not in use.
> diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> index 0976fc4..787ab73 100644
> --- a/include/linux/jump_label.h
> +++ b/include/linux/jump_label.h
> @@ -67,6 +67,11 @@ struct static_key_deferred {
>  	struct delayed_work work;
>  };
>  
> +/* for use with set_true/set_false API */
> +struct static_key_boolean {
> +	struct static_key key;
> +};
> +
>  # include <asm/jump_label.h>
>  # define HAVE_JUMP_LABEL
>  #endif	/* CC_HAVE_ASM_GOTO && CONFIG_JUMP_LABEL */
> @@ -120,6 +125,8 @@ extern int jump_label_text_reserved(void *start, void *end);
>  extern void static_key_slow_inc(struct static_key *key);
>  extern void static_key_slow_dec(struct static_key *key);
>  extern void static_key_slow_dec_deferred(struct static_key_deferred *key);
> +extern void static_key_slow_set_true(struct static_key_boolean *key);
> +extern void static_key_slow_set_false(struct static_key_boolean *key);
>  extern void jump_label_apply_nops(struct module *mod);
>  extern void
>  jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
> @@ -128,6 +135,10 @@ jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
>  	{ .enabled = ATOMIC_INIT(1), .entries = (void *)1 })
>  #define STATIC_KEY_INIT_FALSE ((struct static_key) \
>  	{ .enabled = ATOMIC_INIT(0), .entries = (void *)0 })
> +#define STATIC_KEY_BOOLEAN_INIT_TRUE ((struct static_key_boolean) \
> +	{ .key.enabled = ATOMIC_INIT(1), .key.entries = (void *)1 })
> +#define STATIC_KEY_BOOLEAN_INIT_FALSE ((struct static_key_boolean) \
> +	{ .key.enabled = ATOMIC_INIT(0), .key.entries = (void *)0 })
>  
>  #else  /* !HAVE_JUMP_LABEL */
>  
> @@ -137,6 +148,11 @@ struct static_key {
>  	atomic_t enabled;
>  };
>  
> +/* for use with set_true/set_false API */
> +struct static_key_boolean {
> +	struct static_key key;
> +};
> +
>  static __always_inline void jump_label_init(void)
>  {
>  }
> @@ -174,6 +190,16 @@ static inline void static_key_slow_dec_deferred(struct static_key_deferred *key)
>  	static_key_slow_dec(&key->key);
>  }
>  
> +static inline void static_key_slow_set_true(struct static_key_boolean *key)
> +{
> +	atomic_set(&key->key.enabled, 1);
> +}
> +
> +static inline void static_key_slow_set_false(struct static_key_boolean *key)
> +{
> +	atomic_set(&key->key.enabled, 0);
> +}
> +
>  static inline int jump_label_text_reserved(void *start, void *end)
>  {
>  	return 0;
> @@ -197,6 +223,10 @@ jump_label_rate_limit(struct static_key_deferred *key,
>  		{ .enabled = ATOMIC_INIT(1) })
>  #define STATIC_KEY_INIT_FALSE ((struct static_key) \
>  		{ .enabled = ATOMIC_INIT(0) })
> +#define STATIC_KEY_BOOLEAN_INIT_TRUE ((struct static_key_boolean) \
> +		{ .key.enabled = ATOMIC_INIT(1) })
> +#define STATIC_KEY_BOOLEAN_INIT_FALSE ((struct static_key_boolean) \
> +		{ .key.enabled = ATOMIC_INIT(0) })
>  
>  #endif	/* HAVE_JUMP_LABEL */
>  
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> index 60f48fa..2234a4c 100644
> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -120,6 +120,46 @@ void jump_label_rate_limit(struct static_key_deferred *key,
>  }
>  EXPORT_SYMBOL_GPL(jump_label_rate_limit);
>  
> +void static_key_slow_set_true(struct static_key_boolean *key_boolean)
> +{
> +	struct static_key *key = (struct static_key *)key_boolean;
> +	int enabled;
> +
> +	jump_label_lock();
> +	enabled = atomic_read(&key->enabled);
> +	if (enabled == 1)
> +		goto out;
> +	WARN(enabled != 0, "%s: key->enabled: %d\n", __func__, enabled);
> +	if (!jump_label_get_branch_default(key))
> +		jump_label_update(key, JUMP_LABEL_ENABLE);
> +	else
> +		jump_label_update(key, JUMP_LABEL_DISABLE);
> +	atomic_set(&key->enabled, 1);
> +out:
> +	jump_label_unlock();
> +}
> +EXPORT_SYMBOL_GPL(static_key_slow_set_true);
> +
> +void static_key_slow_set_false(struct static_key_boolean *key_boolean)
> +{
> +	struct static_key *key = (struct static_key *)key_boolean;
> +	int enabled;
> +
> +	jump_label_lock();
> +	enabled = atomic_read(&key->enabled);
> +	if (enabled == 0)
> +		goto out;
> +	WARN(enabled != 1, "%s: key->enabled: %d\n", __func__, enabled);
> +	if (!jump_label_get_branch_default(key))
> +		jump_label_update(key, JUMP_LABEL_DISABLE);
> +	else
> +		jump_label_update(key, JUMP_LABEL_ENABLE);
> +	atomic_set(&key->enabled, 0);
> +out:
> +	jump_label_unlock();
> +}
> +EXPORT_SYMBOL_GPL(static_key_slow_set_false);
> +
>  static int addr_conflict(struct jump_entry *entry, void *start, void *end)
>  {
>  	if (entry->code <= (unsigned long)end &&


