Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab3AYMSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:18:42 -0500
Received: from mail.atsec.com ([195.30.99.214]:47896 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757034Ab3AYMSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:18:38 -0500
Message-ID: <5102781D.9000408@atsec.com>
Date: Fri, 25 Jan 2013 13:18:37 +0100
From: Stephan Mueller <stephan.mueller@atsec.com>
Organization: atsec information security GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kyle McMartin <kyle@redhat.com>
CC: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        rusty@rustcorp.com.au, jstancek@redhat.com
Subject: Re: [PATCH] MODSIGN: flag modules that use cryptoapi and only panic
 if those are unsigned
References: <20130122184357.GD6538@redacted.bos.redhat.com> <8615.1358940375@warthog.procyon.org.uk> <50FFFF48.6020608@atsec.com> <20130124190610.GI6538@redacted.bos.redhat.com>
In-Reply-To: <20130124190610.GI6538@redacted.bos.redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.01.2013 20:06:10, +0100, Kyle McMartin <kyle@redhat.com> wrote:

Hi Kyle,
> After thinking about it a while, this seems like the best way to solve
> the problem, although it does still kind of offend my delicate
> sensibilities...
> 
> Doing this check in the crypto layer seems kind of like a layering
> violation to me (and, to be honest, I think it'd be a gross-hack getting
> from the callee back to the caller module.)
> 
> Instead, doing it in kernel/module.c and looking at the undefined symbol
> list again looks to me like an ordering problem since we're doing the
> signature check before we've even done the elf header check. We'd have
> to move the panic to a part of the module code that may not necessarily
> make sense.
> 
> Whereas checking the undefined symbol list at modpost time is fairly
> logical, and adding a new MODULE_INFO entry in the CONFIG_CRYPTO_FIPS
> case is a well understood thing to do, and should catch all the crypto
> registrations regardless of where they exist in-tree...
> 
> Seems to build and work with both values of CONFIG_CRYPTO_FIPS.
> 
> Thoughts?

This patch is absolutely ok with FIPS requirements.

But I think that patch falls short, because the crypto API offers other
register functions:

$ pwd
.../include/crypto
$ grep -r crypto_register *
algapi.h:int crypto_register_template(struct crypto_template *tmpl);
algapi.h:int crypto_register_instance(struct crypto_template *tmpl,
internal/compress.h:extern int crypto_register_pcomp(struct pcomp_alg *alg);
internal/hash.h:int crypto_register_ahash(struct ahash_alg *alg);
internal/hash.h:int crypto_register_shash(struct shash_alg *alg);
internal/hash.h:int crypto_register_shashes(struct shash_alg *algs, int
count);

$ pwd
...crypto
$ grep -r crypto_register algapi.c  | grep EXPORT
EXPORT_SYMBOL_GPL(crypto_register_alg);
EXPORT_SYMBOL_GPL(crypto_register_algs);
EXPORT_SYMBOL_GPL(crypto_register_template);
EXPORT_SYMBOL_GPL(crypto_register_instance);
EXPORT_SYMBOL_GPL(crypto_register_notifier);

So, please add these calls to your code too.

Though, I have one concern that it does not catches all circumstances.
What happens, if a crypto algo implementation consists of two KOs where
one KO has the register function and the other KO implements other
aspects of the cipher? In this case, both KOs must be covered with the
check. Can that happen in general?

Also, currently lib/sha1.c and lib/md5.c are statically compiled -- so
we are fine. Though, is it possible that they may be offloaded into KOs
in the future? If yes, they would need to be covered too.

Ciao
Stephan

> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> 
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2459,8 +2459,10 @@ static int module_sig_check(struct load_info *info)
>  		return 0;
>  	}
>  
> -	/* Not having a signature is only an error if we're strict. */
> -	if (err < 0 && fips_enabled)
> +	/* Not having a signature is only an error if we're strict, and
> +	 * the module registers a crypto algorithm (checked in modpost)
> +	 */
> +	if (err < 0 && fips_enabled && !get_modinfo(info, "crypto_fips"))
>  		panic("Module verification failed with error %d in FIPS mode\n",
>  		      err);
>  	if (err == -ENOKEY && !sig_enforce)
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index ff36c50..79f46e2 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -1888,6 +1888,23 @@ static void add_staging_flag(struct buffer *b, const char *name)
>  		buf_printf(b, "\nMODULE_INFO(staging, \"Y\");\n");
>  }
>  
> +static void add_crypto_flag(struct buffer *b, struct module *mod)
> +{
> +#if defined(CONFIG_CRYPTO_FIPS)
> +	struct symbol *s;
> +
> +	/* iterate unresolved symbols looking for...
> +	 *  - crypto_register_algs
> +	 */
> +	for (s = mod->unres; s; s = s->next) {
> +		if (strcmp("crypto_register_algs", s->name) == 0)
> +			buf_printf(b, "\nMODULE_INFO(crypto_fips, \"Y\");\n");
> +	}
> +#else
> +	return;
> +#endif /*CONFIG_CRYPTO_FIPS*/
> +}
> +
>  /**
>   * Record CRCs for unresolved symbols
>   **/
> @@ -2202,6 +2219,7 @@ int main(int argc, char **argv)
>  		add_header(&buf, mod);
>  		add_intree_flag(&buf, !external_module);
>  		add_staging_flag(&buf, mod->name);
> +		add_crypto_flag(&buf, mod);
>  		err |= add_versions(&buf, mod);
>  		add_depends(&buf, mod, modules);
>  		add_moddevtable(&buf, mod);
> 

