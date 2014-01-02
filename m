Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbaABNqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 08:46:46 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38199 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaABNqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 08:46:44 -0500
Date: Thu, 2 Jan 2014 16:46:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ivaylo DImitrov <ivo.g.dimitrov.75@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Ivaylo Dimitrov <freemangordon@abv.bg>,
        pavel@ucw.cz, pali.rohar@gmail.com
Subject: Re: [PATCH] Staging: tidspbridge: Use hashtable implementation
Message-ID: <20140102134635.GD28413@mwanda>
References: <1387992592-3208-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387992592-3208-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor nits.  Nothing major.

On Wed, Dec 25, 2013 at 07:29:52PM +0200, Ivaylo DImitrov wrote:
> From: Ivaylo Dimitrov <freemangordon@abv.bg>
> 
> Use upstream hashtable implementation instead of generic code
> 
> Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>

Send from the same email you are using to Sign so we can at least
verify that small thing.

> ---
>  drivers/staging/tidspbridge/gen/gh.c               |  141 +++++++-------------
>  drivers/staging/tidspbridge/include/dspbridge/gh.h |    6 +-
>  drivers/staging/tidspbridge/pmgr/dbll.c            |   47 ++++---
>  3 files changed, 78 insertions(+), 116 deletions(-)
> 
> diff --git a/drivers/staging/tidspbridge/gen/gh.c b/drivers/staging/tidspbridge/gen/gh.c
> index 25eaef7..41a0a4f 100644
> --- a/drivers/staging/tidspbridge/gen/gh.c
> +++ b/drivers/staging/tidspbridge/gen/gh.c
> @@ -14,56 +14,46 @@
>   * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
>   */
>  
> -#include <linux/types.h>
> +#include <linux/err.h>
> +#include <linux/hashtable.h>
> +#include <linux/slab.h>
>  
> -#include <dspbridge/host_os.h>
> -#include <dspbridge/gh.h>
> -
> -struct element {
> -	struct element *next;
> +struct gh_node {
> +	struct hlist_node hl;
>  	u8 data[1];

Use a zero size array here so that you can remove the " - 1" from
"sizeof(struct gh_node) - 1 + hash_tab->val_size".  (Fix in later
patches).

>  };
>  
> +#define GH_HASH_ORDER 8
> +
>  struct gh_t_hash_tab {
> -	u16 max_bucket;
> -	u16 val_size;
> -	struct element **buckets;
> -	 u16(*hash) (void *, u16);
> -	 bool(*match) (void *, void *);
> -	void (*delete) (void *);
> +	u32 val_size;
> +	DECLARE_HASHTABLE(hash_table, GH_HASH_ORDER);
> +	u32 (*hash)(void *);
> +	bool (*match)(void *, void *);
> +	void (*delete)(void *);
>  };
>  
> -static void noop(void *p);
> -
>  /*
>   *  ======== gh_create ========
>   */
>  
> -struct gh_t_hash_tab *gh_create(u16 max_bucket, u16 val_size,
> -				u16(*hash) (void *, u16), bool(*match) (void *,
> -									void *),
> -				void (*delete) (void *))
> +struct gh_t_hash_tab *gh_create(u32 val_size,u32 (*hash)(void *),
> +				bool (*match)(void *, void *),
> +				void (*delete)(void *))
>  {
>  	struct gh_t_hash_tab *hash_tab;
> -	u16 i;
> +
>  	hash_tab = kzalloc(sizeof(struct gh_t_hash_tab), GFP_KERNEL);
> -	if (hash_tab == NULL)
> -		return NULL;
> -	hash_tab->max_bucket = max_bucket;
> +

Don't put a blank line here between the call and the error handling.

> +	if (!hash_tab)
> +		return ERR_PTR(-ENOMEM);
> +
> +	hash_init(hash_tab->hash_table);
> +
>  	hash_tab->val_size = val_size;
>  	hash_tab->hash = hash;
>  	hash_tab->match = match;
> -	hash_tab->delete = delete == NULL ? noop : delete;
> -
> -	hash_tab->buckets =
> -	    kzalloc(sizeof(struct element *) * max_bucket, GFP_KERNEL);
> -	if (hash_tab->buckets == NULL) {
> -		gh_delete(hash_tab);
> -		return NULL;
> -	}
> -
> -	for (i = 0; i < max_bucket; i++)
> -		hash_tab->buckets[i] = NULL;
> +	hash_tab->delete = delete;
>  
>  	return hash_tab;
>  }
> @@ -73,21 +63,16 @@ struct gh_t_hash_tab *gh_create(u16 max_bucket, u16 val_size,
>   */
>  void gh_delete(struct gh_t_hash_tab *hash_tab)
>  {
> -	struct element *elem, *next;
> -	u16 i;
> -
> -	if (hash_tab != NULL) {
> -		if (hash_tab->buckets != NULL) {
> -			for (i = 0; i < hash_tab->max_bucket; i++) {
> -				for (elem = hash_tab->buckets[i]; elem != NULL;
> -				     elem = next) {
> -					next = elem->next;
> -					(*hash_tab->delete) (elem->data);
> -					kfree(elem);
> -				}
> -			}
> -
> -			kfree(hash_tab->buckets);
> +	struct gh_node *n;
> +	struct hlist_node *tmp;
> +	u32 i;
> +
> +	if (hash_tab) {
> +		hash_for_each_safe(hash_tab->hash_table, i, tmp, n, hl) {
> +			hash_del(&n->hl);
> +			if(hash_tab->delete)

Use checkpatch.pl.

> +				hash_tab->delete(n->data);
> +			kfree(n);
>  		}
>  
>  		kfree(hash_tab);
> @@ -100,16 +85,14 @@ void gh_delete(struct gh_t_hash_tab *hash_tab)
>  
>  void *gh_find(struct gh_t_hash_tab *hash_tab, void *key)
>  {
> -	struct element *elem;
> -
> -	elem = hash_tab->buckets[(*hash_tab->hash) (key, hash_tab->max_bucket)];
> +	struct gh_node *n;
> +	u32 key_hash = hash_tab->hash(key);
>  
> -	for (; elem; elem = elem->next) {
> -		if ((*hash_tab->match) (key, elem->data))
> -			return elem->data;
> -	}
> +	hash_for_each_possible(hash_tab->hash_table, n, hl, key_hash)
> +		if (hash_tab->match(key, n->data))
> +			return n->data;

Multi-line indents get curly braces for readability.

>  
> -	return NULL;
> +	return ERR_PTR(-ENODATA);
>  }
>  
>  /*
> @@ -118,36 +101,19 @@ void *gh_find(struct gh_t_hash_tab *hash_tab, void *key)
>  
>  void *gh_insert(struct gh_t_hash_tab *hash_tab, void *key, void *value)
>  {
> -	struct element *elem;
> -	u16 i;
> -	char *src, *dst;
> +	struct gh_node *n;
>  
> -	elem = kzalloc(sizeof(struct element) - 1 + hash_tab->val_size,
> +	n = kmalloc(sizeof(struct gh_node) - 1 + hash_tab->val_size,
>  			GFP_KERNEL);
> -	if (elem != NULL) {
>  
> -		dst = (char *)elem->data;
> -		src = (char *)value;
> -		for (i = 0; i < hash_tab->val_size; i++)
> -			*dst++ = *src++;
> +	if(!n)
> +		return ERR_PTR(-ENOMEM);
>  
> -		i = (*hash_tab->hash) (key, hash_tab->max_bucket);
> -		elem->next = hash_tab->buckets[i];
> -		hash_tab->buckets[i] = elem;
> +	INIT_HLIST_NODE(&n->hl);
> +	hash_add(hash_tab->hash_table, &n->hl, hash_tab->hash(key));
> +	memcpy(n->data, value, hash_tab->val_size);
>  
> -		return elem->data;
> -	}
> -
> -	return NULL;
> -}
> -
> -/*
> - *  ======== noop ========
> - */
> -/* ARGSUSED */
> -static void noop(void *p)
> -{
> -	p = p;			/* stifle compiler warning */
> +	return n->data;
>  }
>  
>  #ifdef CONFIG_TIDSPBRIDGE_BACKTRACE
> @@ -162,16 +128,11 @@ static void noop(void *p)
>  void gh_iterate(struct gh_t_hash_tab *hash_tab,
>  		void (*callback)(void *, void *), void *user_data)
>  {
> -	struct element *elem;
> +	struct gh_node *n;
>  	u32 i;
>  
> -	if (hash_tab && hash_tab->buckets)
> -		for (i = 0; i < hash_tab->max_bucket; i++) {
> -			elem = hash_tab->buckets[i];
> -			while (elem) {
> -				callback(&elem->data, user_data);
> -				elem = elem->next;
> -			}
> -		}
> +	if (hash_tab)
> +		hash_for_each(hash_tab->hash_table, i, n, hl)
> +			callback(&n->data, user_data);

Multi-line indents get curly braces.  But it would be better to reverse
this anyway.

	if (!hash_tab)
		return;

	hash_for_each(hash_tab->hash_table, i, n, hl)
		callback(&n->data, user_data);

>  }
>  #endif
> diff --git a/drivers/staging/tidspbridge/include/dspbridge/gh.h b/drivers/staging/tidspbridge/include/dspbridge/gh.h
> index da85079..6ce69f4 100644
> --- a/drivers/staging/tidspbridge/include/dspbridge/gh.h
> +++ b/drivers/staging/tidspbridge/include/dspbridge/gh.h
> @@ -18,9 +18,9 @@
>  #define GH_
>  #include <dspbridge/host_os.h>
>  
> -extern struct gh_t_hash_tab *gh_create(u16 max_bucket, u16 val_size,
> -				       u16(*hash) (void *, u16),
> -				       bool(*match) (void *, void *),
> +extern struct gh_t_hash_tab *gh_create(u32 val_size,
> +				       u32 (*hash)(void *),
> +				       bool (*match)(void *, void *),
>  				       void (*delete) (void *));
>  extern void gh_delete(struct gh_t_hash_tab *hash_tab);
>  extern void *gh_find(struct gh_t_hash_tab *hash_tab, void *key);
> diff --git a/drivers/staging/tidspbridge/pmgr/dbll.c b/drivers/staging/tidspbridge/pmgr/dbll.c
> index 41e88ab..234a433 100644
> --- a/drivers/staging/tidspbridge/pmgr/dbll.c
> +++ b/drivers/staging/tidspbridge/pmgr/dbll.c
> @@ -33,9 +33,6 @@
>  #include <dspbridge/dbll.h>
>  #include <dspbridge/rmm.h>
>  
> -/* Number of buckets for symbol hash table */
> -#define MAXBUCKETS 211
> -
>  /* Max buffer length */
>  #define MAXEXPR 128
>  
> @@ -183,7 +180,7 @@ static int execute(struct dynamic_loader_initialize *this, ldr_addr start);
>  static void release(struct dynamic_loader_initialize *this);
>  
>  /* symbol table hash functions */
> -static u16 name_hash(void *key, u16 max_bucket);
> +static u32 name_hash(void *key);
>  static bool name_match(void *key, void *sp);
>  static void sym_delete(void *value);
>  
> @@ -280,7 +277,7 @@ bool dbll_get_addr(struct dbll_library_obj *zl_lib, char *name,
>  	bool status = false;
>  
>  	sym = (struct dbll_symbol *)gh_find(zl_lib->sym_tab, name);

Remove the unneeded casts...  (in later patches).

> -	if (sym != NULL) {
> +	if (!IS_ERR(sym)) {
>  		*sym_val = &sym->value;
>  		status = true;
>  	}

When ever I see a !IS_ERR() then it weirds me out.  In this case my
intuition is correct and this function is super uglier than necessary
because of all the stupid debug code.  It should just be:

bool dbll_get_addr(struct dbll_library_obj *zl_lib, char *name,
		   struct dbll_sym_val **sym_val)
{
	struct dbll_symbol *sym;

	sym = gh_find(zl_lib->sym_tab, name);
	if (IS_ERR(sym))
		return false;

	*sym_val = &sym->value;
	return true;
}

> @@ -322,7 +319,7 @@ bool dbll_get_c_addr(struct dbll_library_obj *zl_lib, char *name,
>  	/* Check for C name, if not found */
>  	sym = (struct dbll_symbol *)gh_find(zl_lib->sym_tab, cname);
>  
> -	if (sym != NULL) {
> +	if (!IS_ERR(sym)) {
>  		*sym_val = &sym->value;
>  		status = true;
>  	}
> @@ -416,12 +413,13 @@ int dbll_load(struct dbll_library_obj *lib, dbll_flags flags,
>  		/* Create a hash table for symbols if not already created */
>  		if (zl_lib->sym_tab == NULL) {
>  			got_symbols = false;
> -			zl_lib->sym_tab = gh_create(MAXBUCKETS,
> -						    sizeof(struct dbll_symbol),
> +			zl_lib->sym_tab = gh_create(sizeof(struct dbll_symbol),
>  						    name_hash,
>  						    name_match, sym_delete);
> -			if (zl_lib->sym_tab == NULL)
> -				status = -ENOMEM;
> +			if (IS_ERR(zl_lib->sym_tab)) {
> +				status = PTR_ERR(zl_lib->sym_tab);
> +				zl_lib->sym_tab = NULL;
> +			}
>  
>  		}
>  		/*
> @@ -593,10 +591,11 @@ int dbll_open(struct dbll_tar_obj *target, char *file, dbll_flags flags,
>  		goto func_cont;
>  
>  	zl_lib->sym_tab =
> -	    gh_create(MAXBUCKETS, sizeof(struct dbll_symbol), name_hash,
> -		      name_match, sym_delete);
> -	if (zl_lib->sym_tab == NULL) {
> -		status = -ENOMEM;
> +	    gh_create(sizeof(struct dbll_symbol), name_hash, name_match,
> +		      sym_delete);
> +	if (IS_ERR(zl_lib->sym_tab)) {
> +		status = PTR_ERR(zl_lib->sym_tab);
> +		zl_lib->sym_tab = NULL;
>  	} else {
>  		/* Do a fake load to get symbols - set write func to no_op */
>  		zl_lib->init.dl_init.writemem = no_op;
> @@ -793,10 +792,9 @@ static int dof_open(struct dbll_library_obj *zl_lib)
>  /*
>   *  ======== name_hash ========
>   */
> -static u16 name_hash(void *key, u16 max_bucket)
> +static u32 name_hash(void *key)
>  {
> -	u16 ret;
> -	u16 hash;
> +	u32 hash;
>  	char *name = (char *)key;
>  
>  	hash = 0;
> @@ -806,9 +804,7 @@ static u16 name_hash(void *key, u16 max_bucket)
>  		hash ^= *name++;
>  	}
>  
> -	ret = hash % max_bucket;
> -
> -	return ret;
> +	return hash;
>  }
>  
>  /*
> @@ -937,7 +933,7 @@ static struct dynload_symbol *find_in_symbol_table(struct dynamic_loader_sym
>  						   *this, const char *name,
>  						   unsigned moduleid)
>  {
> -	struct dynload_symbol *ret_sym;
> +	struct dynload_symbol *ret_sym = NULL;
>  	struct ldr_symbol *ldr_sym = (struct ldr_symbol *)this;
>  	struct dbll_library_obj *lib;
>  	struct dbll_symbol *sym;
> @@ -945,7 +941,9 @@ static struct dynload_symbol *find_in_symbol_table(struct dynamic_loader_sym
>  	lib = ldr_sym->lib;
>  	sym = (struct dbll_symbol *)gh_find(lib->sym_tab, (char *)name);
>  

Don't put a blank line between the function and the error handling.  (In
this case it's actually "success handling", I suppose.  :P).

> -	ret_sym = (struct dynload_symbol *)&sym->value;
> +	if (!IS_ERR(sym))
> +		ret_sym = (struct dynload_symbol *)&sym->value;
> +
>  	return ret_sym;

Again, reverse the IS_ERR() check and return directly.  Use the struct
pointer instead of the address of the first member.

	sym = gh_find(lib->sym_tab, (char *)name);
	if (IS_ERR(sym))
		return NULL;

	return (struct dbll_symbol *)sym;

That way is easier to read.  gh_find() should accept const pointers btw,
we shouldn't have to cast away the const in each of the callers.

>  }
>  
> @@ -991,8 +989,11 @@ static struct dynload_symbol *dbll_add_to_symbol_table(struct dynamic_loader_sym
>  		sym_ptr =
>  		    (struct dbll_symbol *)gh_insert(lib->sym_tab, (void *)name,
>  						    (void *)&symbol);
> -		if (sym_ptr == NULL)
> +		if (IS_ERR(sym_ptr))
> +		{
>  			kfree(symbol.name);
> +			sym_ptr = NULL;
> +		}

Checkpatch.  Same issues as before for a later patch series.

regards,
dan carpenter


