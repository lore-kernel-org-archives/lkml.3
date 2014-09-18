Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbaIRPLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:11:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:34956 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013AbaIRPLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:11:04 -0400
Date: Thu, 18 Sep 2014 12:10:57 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v3 1/2] perf tool: improves DSO long names search speed
 with RB tree
Message-ID: <20140918151057.GG2770@kernel.org>
References: <1411047021-38823-1-git-send-email-Waiman.Long@hp.com>
 <1411047021-38823-2-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411047021-38823-2-git-send-email-Waiman.Long@hp.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 18, 2014 at 09:30:20AM -0400, Waiman Long escreveu:
> +++ b/tools/perf/util/dso.c
> @@ -651,6 +651,80 @@ struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
>  	return dso;
  
> +/*
> + * RB root of DSOs sorted by the long name
> + */
> +struct rb_root dso__root = { NULL };

Why do we still have a global variable for this? I thought that we would
be having this in struct machine?

Ok, I shouldn't have done this, but I went on and looked at the second
patch, and there, this goes away, why not avoid introducing the global
in the first place?

I.e. the existing code operates on a data structure that holds struct
dsos, you are switching to a new data structure, so it looked natural to
me to do this in one step, no?

Also at some point I thought about adding rb_tree helper functions to do
some rb__for_each() like operation, i.e. to sequentially access the
rb_tree instead of using it for searching using its key. PeterZ
rightfully nacked that because that would, IIRC, encourage people to use
a rb_tree to do linear searches for normal operation, i.e. not just for
rb_tree__printf() dump like routines:

https://lkml.org/lkml/2010/1/13/227

Also I saw at least one place where some foo__for_each_entry_safe() is
used but the loop doesn't look like it will remove/add anything to the
data structure that is being made "_safe", i.e. it should remain
foo__for_each_entry(), as it was before.

So, I would _keep_ the list_head, or else replace it with a another
rb_node to do lookups on it by shortname the same way we do for long
names.

The cheapest thing now would be for solving your problem, i.e. use a
rb_tree for searching for long names, keep the list_head for short names
linear searches.

I suggest having a

struct dsos {
	struct list_head short_names;
	struct rb_root	 long_names;
};

Then make struct machine use this type for:

	struct dsos	kernel_dsos, user_dsos;

Then all those dsos__find* routines stop receiving a list_head pointer
and start receiving a "struct dsos" instance.

That way it can add the dso to both containers, the one "sorted" by
short names (that linear search, just like before) and to the rb_tree
sorted by long names.

- Arnaldo

> +/*
> + * Find a matching entry and/or link current entry to RB tree.
> + * Either one of the dso or name parameter must be non-NULL or the
> + * function will not work.
> + */
> +static struct dso *dso__findlink_by_longname(struct rb_root *root,
> +					     struct dso *dso, const char *name)
> +{
> +	struct rb_node **p = &root->rb_node;
> +	struct rb_node  *parent = NULL;
> +	int warned = false;
> +
> +	if (!name)
> +		name = dso->long_name;
> +	/*
> +	 * Find node with the matching name
> +	 */
> +	while (*p) {
> +		struct dso *this = rb_entry(*p, struct dso, rb_node);
> +		long rc = (long)strcmp(name, this->long_name);
> +
> +		parent = *p;
> +		if (rc == 0) {
> +			/*
> +			 * In case the new DSO is a duplicate of an existing
> +			 * one, print an one-time warning & sort the entry
> +			 * by its DSO address.
> +			 */
> +			if (!dso || (dso == this))
> +				return this;	/* Find matching dso */
> +			/*
> +			 * The kernel DSOs may have duplicated long name,
> +			 * so don't print warning for them.
> +			 */
> +			if (!warned && !strstr(name, "kernel.kallsyms")
> +				    && !strstr(name, "/vmlinux")) {
> +				pr_warning("Duplicated dso long name: %s\n",
> +					   name);
> +				warned = true;
> +			}
> +			rc = (long)dso - (long)this;
> +		}
> +		if (rc < 0)
> +			p = &parent->rb_left;
> +		else
> +			p = &parent->rb_right;
> +	}
> +	if (dso) {
> +		/* Add new node and rebalance tree */
> +		rb_link_node(&dso->rb_node, parent, p);
> +		rb_insert_color(&dso->rb_node, root);
> +	}
> +	return NULL;
> +}
> +
> +static inline struct dso *
> +dso__find_by_longname(struct rb_root *root, const char *name)
> +{
> +	return dso__findlink_by_longname(root, NULL, name);
> +}
> +
> +/*
> + * Unlink the longname-sorted RB tree node
> + */
> +static inline void dso__rb_unlink(struct rb_root *root, struct dso *dso)
> +{
> +	rb_erase(&dso->rb_node, root);
> +}
> +
>  void dso__set_long_name(struct dso *dso, const char *name, bool name_allocated)
>  {
>  	if (name == NULL)
> @@ -753,6 +827,8 @@ struct dso *dso__new(const char *name)
>  		dso->a2l_fails = 1;
>  		dso->kernel = DSO_TYPE_USER;
>  		dso->needs_swap = DSO_SWAP__UNSET;
> +		dso->rb_root = NULL;
> +		RB_CLEAR_NODE(&dso->rb_node);
>  		INIT_LIST_HEAD(&dso->node);
>  		INIT_LIST_HEAD(&dso->data.open_entry);
>  	}
> @@ -775,6 +851,10 @@ void dso__delete(struct dso *dso)
>  		zfree((char **)&dso->long_name);
>  		dso->long_name_allocated = false;
>  	}
> +	if (dso->rb_root) {
> +		dso__rb_unlink(dso->rb_root, dso);
> +		dso->rb_root = NULL;
> +	}
>  
>  	dso__data_close(dso);
>  	dso_cache__free(&dso->data.cache);
> @@ -852,6 +932,8 @@ bool __dsos__read_build_ids(struct list_head *head, bool with_hits)
>  void dsos__add(struct list_head *head, struct dso *dso)
>  {
>  	list_add_tail(&dso->node, head);
> +	dso__findlink_by_longname(&dso__root, dso, NULL);
> +	dso->rb_root = &dso__root;
>  }
>  
>  struct dso *dsos__find(const struct list_head *head, const char *name, bool cmp_short)
> @@ -864,10 +946,7 @@ struct dso *dsos__find(const struct list_head *head, const char *name, bool cmp_
>  				return pos;
>  		return NULL;
>  	}
> -	list_for_each_entry(pos, head, node)
> -		if (strcmp(pos->long_name, name) == 0)
> -			return pos;
> -	return NULL;
> +	return dso__find_by_longname(&dso__root, name);
>  }
>  
>  struct dso *__dsos__findnew(struct list_head *head, const char *name)
> diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
> index 5e463c0..75cda1d 100644
> --- a/tools/perf/util/dso.h
> +++ b/tools/perf/util/dso.h
> @@ -92,6 +92,8 @@ struct dso_cache {
>  
>  struct dso {
>  	struct list_head node;
> +	struct rb_node   rb_node;	/* rbtree sorted by long name */
> +	struct rb_root   *rb_root;	/* pointer to rbtree root */
>  	struct rb_root	 symbols[MAP__NR_TYPES];
>  	struct rb_root	 symbol_names[MAP__NR_TYPES];
>  	void		 *a2l;
> -- 
> 1.7.1
