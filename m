Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab3JQKfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:35:36 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:63203 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3JQKff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:35:35 -0400
Message-ID: <525FBD71.7000608@redhat.com>
Date: Thu, 17 Oct 2013 12:35:29 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 1/7] static_key: flush rate limit timer on rmmod
References: <1382004631-25895-1-git-send-email-rkrcmar@redhat.com> <1382004631-25895-2-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1382004631-25895-2-git-send-email-rkrcmar@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/10/2013 12:10, Radim Krčmář ha scritto:
> Fix a bug when we free module memory while timer is pending by marking
> deferred static keys and flushing the timer on module unload.
> 
> Also make static_key_rate_limit() useable more than once.
> 
> Reproducer: (host crasher)
>   modprobe kvm_intel
>   (sleep 1; echo quit) \
>     | qemu-kvm -kernel /dev/null -monitor stdio &
>   sleep 0.5
>   until modprobe -rv kvm_intel 2>/dev/null; do true; done
>   modprobe -v kvm_intel
> 
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> ---
> Very hacky; I've already queued generalizing ratelimit and applying it
> here, but there is still a lot to do on static keys ...
> 
>  include/linux/jump_label.h |  1 +
>  kernel/jump_label.c        | 17 ++++++++++++++++-
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> index a507907..848bd15 100644
> --- a/include/linux/jump_label.h
> +++ b/include/linux/jump_label.h
> @@ -58,6 +58,7 @@ struct static_key {
>  #ifdef CONFIG_MODULES
>  	struct static_key_mod *next;
>  #endif
> +	atomic_t deferred;
>  };
>  
>  # include <asm/jump_label.h>
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> index 297a924..7018042 100644
> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -116,8 +116,9 @@ EXPORT_SYMBOL_GPL(static_key_slow_dec_deferred);
>  void jump_label_rate_limit(struct static_key_deferred *key,
>  		unsigned long rl)
>  {
> +	if (!atomic_xchg(&key->key.deferred, 1))
> +		INIT_DELAYED_WORK(&key->work, jump_label_update_timeout);

Can it actually happen that jump_label_rate_limit is called multiple
times?  If so, this hunk alone would be a separate bugfix.  I don't
think all the concurrency that you're protecting against can actually
happen, but in any case I'd just take the jump_label_lock() instead of
using atomics.

It's also not necessary to use a new field, since you can just check
key->timeout.

All this gives something like this for static_key_rate_limit_flush:

        if (key->timeout) {
		jump_label_lock();
		if (key->enabled) {
			jump_label_unlock();
			flush_delayed_work(&dkey->work);
		} else
			jump_label_unlock();
	}

Paolo

>  	key->timeout = rl;
> -	INIT_DELAYED_WORK(&key->work, jump_label_update_timeout);
>  }
>  EXPORT_SYMBOL_GPL(jump_label_rate_limit);
>  
> @@ -185,6 +186,14 @@ static enum jump_label_type jump_label_type(struct static_key *key)
>  	return JUMP_LABEL_DISABLE;
>  }
>  
> +static void static_key_rate_limit_flush(struct static_key *key)
> +{
> +	struct static_key_deferred *dkey =
> +		container_of(key, struct static_key_deferred, key);
> +	if (atomic_read(&key->deferred))
> +		flush_delayed_work(&dkey->work);
> +}
> +
>  void __init jump_label_init(void)
>  {
>  	struct jump_entry *iter_start = __start___jump_table;
> @@ -334,6 +343,12 @@ static void jump_label_del_module(struct module *mod)
>  
>  		key = (struct static_key *)(unsigned long)iter->key;
>  
> +		/* We could also check if the static_key is used in its
> +		 * defining module and skip this flush then.
> +		 * (Rewrite of ratelimit in planned, so we don't care much)
> +		 */
> +		static_key_rate_limit_flush(key);
> +
>  		if (__module_address(iter->key) == mod)
>  			continue;
>  
> 

