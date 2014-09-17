Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbaIQOvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:51:15 -0400
Received: from mail.kernel.org ([198.145.19.201]:37928 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363AbaIQOvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 10:51:14 -0400
Date: Wed, 17 Sep 2014 11:51:02 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v2] perf mem: improves DSO long names search speed with
 RB tree
Message-ID: <20140917145102.GA2770@kernel.org>
References: <1410894499-27609-1-git-send-email-Waiman.Long@hp.com>
 <1410894499-27609-2-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410894499-27609-2-git-send-email-Waiman.Long@hp.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 16, 2014 at 03:08:19PM -0400, Waiman Long escreveu:
> +++ b/tools/perf/util/dso.c
> @@ -611,17 +611,93 @@ struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
>  	return dso;
>  }
>  
> +/*
> + * RB root of DSOs sorted by the long name
> + */
> +static struct rb_root dso__longname_root = { NULL };

Use RB_ROOT, like in:

[acme@zoo linux]$ grep -w rb_root mm/vmalloc.c 
static struct rb_root vmap_area_root = RB_ROOT;
[acme@zoo linux]$ 

But then can't this be made non-static, i.e. at the 'struct machine'
level? I.e.  it is more likely that DSOs with the same long name are
really the same thing on a single 'struct machine', not accross multiple
ones or even multiple sessions (i.e. across multiple 'struct machines').

IIRC Adrian also pointed this out.

- Arnaldo

> +/*
> + * Find a matching entry and/or link current entry to RB tree.
> + * Either one of the dso or name parameter must be non-NULL or the
> + * function will not work.
> + */
> +static struct dso *
> +dso__findlink_by_longname(struct dso *dso, const char *name)
> +{
> +	struct rb_node **p = &dso__longname_root.rb_node;
> +	struct rb_node  *parent = NULL;
> +	int warned = false;
> +
> +	if (!name)
> +		name = dso->long_name;
> +	/*
> +	 * Find node with the matching name
> +	 */
> +	while (*p) {
> +		struct dso *this = rb_entry(*p, struct dso, longname_rb_node);
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
> +			if (!warned) {
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
> +		rb_link_node(&dso->longname_rb_node, parent, p);
> +		rb_insert_color(&dso->longname_rb_node, &dso__longname_root);
> +	}
> +	return NULL;
> +}
> +
> +static inline struct dso *
> +dso__find_by_longname(const char *name)
> +{
> +	return dso__findlink_by_longname(NULL, name);
> +}
> +
> +/*
> + * Unlink the longname-sorted RB tree node
> + */
> +static inline void dso__unlink_longname_node(struct dso *dso)
> +{
> +	rb_erase(&dso->longname_rb_node, &dso__longname_root);
> +}
> +
>  void dso__set_long_name(struct dso *dso, const char *name, bool name_allocated)
>  {
>  	if (name == NULL)
>  		return;
>  
> +	if (dso->long_name) {
> +		if (!strcmp(dso->long_name, name))
> +			return;
> +		dso__unlink_longname_node(dso);
> +	}
> +
>  	if (dso->long_name_allocated)
>  		free((char *)dso->long_name);
>  
>  	dso->long_name		 = name;
>  	dso->long_name_len	 = strlen(name);
>  	dso->long_name_allocated = name_allocated;
> +	(void)dso__findlink_by_longname(dso, name);
>  }
>  
>  void dso__set_short_name(struct dso *dso, const char *name, bool name_allocated)
> @@ -695,6 +771,8 @@ struct dso *dso__new(const char *name)
>  	if (dso != NULL) {
>  		int i;
>  		strcpy(dso->name, name);
> +		RB_CLEAR_NODE(&dso->longname_rb_node);
> +		dso->long_name = NULL;
>  		dso__set_long_name(dso, dso->name, false);
>  		dso__set_short_name(dso, dso->name, false);
>  		for (i = 0; i < MAP__NR_TYPES; ++i)
> @@ -733,6 +811,10 @@ void dso__delete(struct dso *dso)
>  		zfree((char **)&dso->long_name);
>  		dso->long_name_allocated = false;
>  	}
> +	if (dso->long_name) {
> +		dso__unlink_longname_node(dso);
> +		dso->long_name = NULL;
> +	}
>  
>  	dso__data_close(dso);
>  	dso_cache__free(&dso->data.cache);
> @@ -822,10 +904,7 @@ struct dso *dsos__find(const struct list_head *head, const char *name, bool cmp_
>  				return pos;
>  		return NULL;
>  	}
> -	list_for_each_entry(pos, head, node)
> -		if (strcmp(pos->long_name, name) == 0)
> -			return pos;
> -	return NULL;
> +	return dso__find_by_longname(name);
>  }
>  
>  struct dso *__dsos__findnew(struct list_head *head, const char *name)
> diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
> index ad553ba..81a75ee 100644
> --- a/tools/perf/util/dso.h
> +++ b/tools/perf/util/dso.h
> @@ -76,6 +76,7 @@ struct dso {
>  	struct list_head node;
>  	struct rb_root	 symbols[MAP__NR_TYPES];
>  	struct rb_root	 symbol_names[MAP__NR_TYPES];
> +	struct rb_node   longname_rb_node;
>  	void		 *a2l;
>  	char		 *symsrc_filename;
>  	unsigned int	 a2l_fails;
> -- 
> 1.7.1
