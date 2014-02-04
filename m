Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaBDO2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 09:28:01 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:59667 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbaBDO16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 09:27:58 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: restructure for_each macros to fix compile warnings
To: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh@kernel.org>,
        David Howells <dhowells@redhat.com>
In-Reply-To: <1391469424-5245-1-git-send-email-robherring2@gmail.com>
References: <1391469424-5245-1-git-send-email-robherring2@gmail.com>
Date: Tue, 04 Feb 2014 14:27:48 +0000
Message-Id: <20140204142748.6A2A2C407C9@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Feb 2014 17:17:04 -0600, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <robh@kernel.org>
> 
> Commit 00b2c76a6a "include/linux/of.h: make for_each_child_of_node()
> reference its args when CONFIG_OF=n" fixed warnings for unused
> variables, but introduced variable "used uninitialized" warnings.
> Simply initializing the variables would result in "set but not used"
> warnings with W=1.
> 
> Fix both types of warnings by making all the for_each macros
> unconditional and rely on the dummy static inline functions to
> initialize and reference any variables.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Rob Herring <robh@kernel.org>

Acked-by: Grant Likely <grant.likely@linaro.org>

> ---
>  include/linux/of.h | 153 +++++++++++++++++++++++++++++------------------------
>  1 file changed, 84 insertions(+), 69 deletions(-)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 70c64ba..435cb99 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -169,35 +169,15 @@ static inline const char *of_node_full_name(const struct device_node *np)
>  
>  extern struct device_node *of_find_node_by_name(struct device_node *from,
>  	const char *name);
> -#define for_each_node_by_name(dn, name) \
> -	for (dn = of_find_node_by_name(NULL, name); dn; \
> -	     dn = of_find_node_by_name(dn, name))
>  extern struct device_node *of_find_node_by_type(struct device_node *from,
>  	const char *type);
> -#define for_each_node_by_type(dn, type) \
> -	for (dn = of_find_node_by_type(NULL, type); dn; \
> -	     dn = of_find_node_by_type(dn, type))
>  extern struct device_node *of_find_compatible_node(struct device_node *from,
>  	const char *type, const char *compat);
> -#define for_each_compatible_node(dn, type, compatible) \
> -	for (dn = of_find_compatible_node(NULL, type, compatible); dn; \
> -	     dn = of_find_compatible_node(dn, type, compatible))
>  extern struct device_node *of_find_matching_node_and_match(
>  	struct device_node *from,
>  	const struct of_device_id *matches,
>  	const struct of_device_id **match);
> -static inline struct device_node *of_find_matching_node(
> -	struct device_node *from,
> -	const struct of_device_id *matches)
> -{
> -	return of_find_matching_node_and_match(from, matches, NULL);
> -}
> -#define for_each_matching_node(dn, matches) \
> -	for (dn = of_find_matching_node(NULL, matches); dn; \
> -	     dn = of_find_matching_node(dn, matches))
> -#define for_each_matching_node_and_match(dn, matches, match) \
> -	for (dn = of_find_matching_node_and_match(NULL, matches, match); \
> -	     dn; dn = of_find_matching_node_and_match(dn, matches, match))
> +
>  extern struct device_node *of_find_node_by_path(const char *path);
>  extern struct device_node *of_find_node_by_phandle(phandle handle);
>  extern struct device_node *of_get_parent(const struct device_node *node);
> @@ -209,43 +189,11 @@ extern struct device_node *of_get_next_available_child(
>  
>  extern struct device_node *of_get_child_by_name(const struct device_node *node,
>  					const char *name);
> -#define for_each_child_of_node(parent, child) \
> -	for (child = of_get_next_child(parent, NULL); child != NULL; \
> -	     child = of_get_next_child(parent, child))
> -
> -#define for_each_available_child_of_node(parent, child) \
> -	for (child = of_get_next_available_child(parent, NULL); child != NULL; \
> -	     child = of_get_next_available_child(parent, child))
> -
> -static inline int of_get_child_count(const struct device_node *np)
> -{
> -	struct device_node *child;
> -	int num = 0;
> -
> -	for_each_child_of_node(np, child)
> -		num++;
> -
> -	return num;
> -}
> -
> -static inline int of_get_available_child_count(const struct device_node *np)
> -{
> -	struct device_node *child;
> -	int num = 0;
> -
> -	for_each_available_child_of_node(np, child)
> -		num++;
> -
> -	return num;
> -}
>  
>  /* cache lookup */
>  extern struct device_node *of_find_next_cache_node(const struct device_node *);
>  extern struct device_node *of_find_node_with_property(
>  	struct device_node *from, const char *prop_name);
> -#define for_each_node_with_property(dn, prop_name) \
> -	for (dn = of_find_node_with_property(NULL, prop_name); dn; \
> -	     dn = of_find_node_with_property(dn, prop_name))
>  
>  extern struct property *of_find_property(const struct device_node *np,
>  					 const char *name,
> @@ -367,42 +315,53 @@ static inline struct device_node *of_find_node_by_name(struct device_node *from,
>  	return NULL;
>  }
>  
> -static inline struct device_node *of_get_parent(const struct device_node *node)
> +static inline struct device_node *of_find_node_by_type(struct device_node *from,
> +	const char *type)
>  {
>  	return NULL;
>  }
>  
> -static inline bool of_have_populated_dt(void)
> +static inline struct device_node *of_find_matching_node_and_match(
> +	struct device_node *from,
> +	const struct of_device_id *matches,
> +	const struct of_device_id **match)
>  {
> -	return false;
> +	return NULL;
>  }
>  
> -/* Kill an unused variable warning on a device_node pointer */
> -static inline void __of_use_dn(const struct device_node *np)
> +static inline struct device_node *of_get_parent(const struct device_node *node)
>  {
> +	return NULL;
>  }
>  
> -#define for_each_child_of_node(parent, child) \
> -	while (__of_use_dn(parent), __of_use_dn(child), 0)
> +static inline struct device_node *of_get_next_child(
> +	const struct device_node *node, struct device_node *prev)
> +{
> +	return NULL;
> +}
>  
> -#define for_each_available_child_of_node(parent, child) \
> -	while (0)
> +static inline struct device_node *of_get_next_available_child(
> +	const struct device_node *node, struct device_node *prev)
> +{
> +	return NULL;
> +}
>  
> -static inline struct device_node *of_get_child_by_name(
> -					const struct device_node *node,
> -					const char *name)
> +static inline struct device_node *of_find_node_with_property(
> +	struct device_node *from, const char *prop_name)
>  {
>  	return NULL;
>  }
>  
> -static inline int of_get_child_count(const struct device_node *np)
> +static inline bool of_have_populated_dt(void)
>  {
> -	return 0;
> +	return false;
>  }
>  
> -static inline int of_get_available_child_count(const struct device_node *np)
> +static inline struct device_node *of_get_child_by_name(
> +					const struct device_node *node,
> +					const char *name)
>  {
> -	return 0;
> +	return NULL;
>  }
>  
>  static inline int of_device_is_compatible(const struct device_node *device,
> @@ -569,6 +528,13 @@ extern int of_node_to_nid(struct device_node *np);
>  static inline int of_node_to_nid(struct device_node *device) { return 0; }
>  #endif
>  
> +static inline struct device_node *of_find_matching_node(
> +	struct device_node *from,
> +	const struct of_device_id *matches)
> +{
> +	return of_find_matching_node_and_match(from, matches, NULL);
> +}
> +
>  /**
>   * of_property_read_bool - Findfrom a property
>   * @np:		device node from which the property value is to be read.
> @@ -618,6 +584,55 @@ static inline int of_property_read_u32(const struct device_node *np,
>  		s;						\
>  		s = of_prop_next_string(prop, s))
>  
> +#define for_each_node_by_name(dn, name) \
> +	for (dn = of_find_node_by_name(NULL, name); dn; \
> +	     dn = of_find_node_by_name(dn, name))
> +#define for_each_node_by_type(dn, type) \
> +	for (dn = of_find_node_by_type(NULL, type); dn; \
> +	     dn = of_find_node_by_type(dn, type))
> +#define for_each_compatible_node(dn, type, compatible) \
> +	for (dn = of_find_compatible_node(NULL, type, compatible); dn; \
> +	     dn = of_find_compatible_node(dn, type, compatible))
> +#define for_each_matching_node(dn, matches) \
> +	for (dn = of_find_matching_node(NULL, matches); dn; \
> +	     dn = of_find_matching_node(dn, matches))
> +#define for_each_matching_node_and_match(dn, matches, match) \
> +	for (dn = of_find_matching_node_and_match(NULL, matches, match); \
> +	     dn; dn = of_find_matching_node_and_match(dn, matches, match))
> +
> +#define for_each_child_of_node(parent, child) \
> +	for (child = of_get_next_child(parent, NULL); child != NULL; \
> +	     child = of_get_next_child(parent, child))
> +#define for_each_available_child_of_node(parent, child) \
> +	for (child = of_get_next_available_child(parent, NULL); child != NULL; \
> +	     child = of_get_next_available_child(parent, child))
> +
> +#define for_each_node_with_property(dn, prop_name) \
> +	for (dn = of_find_node_with_property(NULL, prop_name); dn; \
> +	     dn = of_find_node_with_property(dn, prop_name))
> +
> +static inline int of_get_child_count(const struct device_node *np)
> +{
> +	struct device_node *child;
> +	int num = 0;
> +
> +	for_each_child_of_node(np, child)
> +		num++;
> +
> +	return num;
> +}
> +
> +static inline int of_get_available_child_count(const struct device_node *np)
> +{
> +	struct device_node *child;
> +	int num = 0;
> +
> +	for_each_available_child_of_node(np, child)
> +		num++;
> +
> +	return num;
> +}
> +
>  #if defined(CONFIG_PROC_FS) && defined(CONFIG_PROC_DEVICETREE)
>  extern void proc_device_tree_add_node(struct device_node *, struct proc_dir_entry *);
>  extern void proc_device_tree_add_prop(struct proc_dir_entry *pde, struct property *prop);
> -- 
> 1.8.3.2
> 

