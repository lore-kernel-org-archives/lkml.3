Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966651Ab3DQO72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:59:28 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38941 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966583Ab3DQO7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:59:24 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 09/28] proc: Move some bits from linux/proc_fs.h to linux/{of.h, signal.h, tty.h} [RFC]
To: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, Jri Slaby <jslaby@suse.cz>
In-Reply-To: <20130416182626.27773.48524.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk> <20130416182626.27773.48524.stgit@warthog.procyon.org.uk>
Date: Wed, 17 Apr 2013 15:59:20 +0100
Message-Id: <20130417145920.35C933E2B73@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Apr 2013 19:26:26 +0100, David Howells <dhowells@redhat.com> wrote:
> Move some bits from linux/proc_fs.h to linux/of.h, signal.h and tty.h.
> 
> Also move proc_tty_init() and proc_device_tree_init() to fs/proc/internal.h as
> they're internal to procfs.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: devicetree-discuss@lists.ozlabs.org
> cc: linux-arch@vger.kernel.org
> cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> cc: Jri Slaby <jslaby@suse.cz>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
> 
>  fs/proc/internal.h      |   16 ++++++++++++++++
>  include/linux/of.h      |   10 ++++++++++
>  include/linux/proc_fs.h |   37 -------------------------------------
>  include/linux/signal.h  |    5 +++++
>  include/linux/tty.h     |    7 +++++++
>  5 files changed, 38 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index 32d8f51..c529b5f 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -198,3 +198,19 @@ extern const struct inode_operations proc_ns_dir_inode_operations;
>  extern const struct file_operations proc_ns_dir_operations;
>  
>  extern int proc_setup_self(struct super_block *);
> +
> +/*
> + * proc_devtree.c
> + */
> +#ifdef CONFIG_PROC_DEVICETREE
> +extern void proc_device_tree_init(void);
> +#endif /* CONFIG_PROC_DEVICETREE */
> +
> +/*
> + * proc_tty.c
> + */
> +#ifdef CONFIG_TTY
> +extern void proc_tty_init(void);
> +#else
> +static inline void proc_tty_init(void) {}
> +#endif
> diff --git a/include/linux/of.h b/include/linux/of.h
> index a0f1292..2d25ff8 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -540,4 +540,14 @@ static inline int of_property_read_u32(const struct device_node *np,
>  	return of_property_read_u32_array(np, propname, out_value, 1);
>  }
>  
> +#if defined(CONFIG_PROC_FS) && defined(CONFIG_PROC_DEVICETREE)
> +extern void proc_device_tree_add_node(struct device_node *, struct proc_dir_entry *);
> +extern void proc_device_tree_add_prop(struct proc_dir_entry *pde, struct property *prop);
> +extern void proc_device_tree_remove_prop(struct proc_dir_entry *pde,
> +					 struct property *prop);
> +extern void proc_device_tree_update_prop(struct proc_dir_entry *pde,
> +					 struct property *newprop,
> +					 struct property *oldprop);
> +#endif
> +
>  #endif /* _LINUX_OF_H */
> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> index 3377224..80d9e24 100644
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -70,36 +70,6 @@ struct proc_dir_entry *proc_create_data(const char *name, umode_t mode,
>  extern void remove_proc_entry(const char *name, struct proc_dir_entry *parent);
>  extern int remove_proc_subtree(const char *name, struct proc_dir_entry *parent);
>  
> -
> -/*
> - * proc_tty.c
> - */
> -struct tty_driver;
> -#ifdef CONFIG_TTY
> -extern void proc_tty_init(void);
> -#else
> -static inline void proc_tty_init(void)
> -{ }
> -#endif
> -extern void proc_tty_register_driver(struct tty_driver *driver);
> -extern void proc_tty_unregister_driver(struct tty_driver *driver);
> -
> -/*
> - * proc_devtree.c
> - */
> -#ifdef CONFIG_PROC_DEVICETREE
> -struct device_node;
> -struct property;
> -extern void proc_device_tree_init(void);
> -extern void proc_device_tree_add_node(struct device_node *, struct proc_dir_entry *);
> -extern void proc_device_tree_add_prop(struct proc_dir_entry *pde, struct property *prop);
> -extern void proc_device_tree_remove_prop(struct proc_dir_entry *pde,
> -					 struct property *prop);
> -extern void proc_device_tree_update_prop(struct proc_dir_entry *pde,
> -					 struct property *newprop,
> -					 struct property *oldprop);
> -#endif /* CONFIG_PROC_DEVICETREE */
> -
>  extern struct proc_dir_entry *proc_symlink(const char *,
>  		struct proc_dir_entry *, const char *);
>  extern struct proc_dir_entry *proc_mkdir(const char *,struct proc_dir_entry *);
> @@ -143,10 +113,6 @@ static inline struct proc_dir_entry *proc_mkdir_mode(const char *name,
>  static inline void proc_set_size(struct proc_dir_entry *de, loff_t size) {}
>  static inline void proc_set_user(struct proc_dir_entry *de, kuid_t uid, kgid_t gid) {}
>  
> -struct tty_driver;
> -static inline void proc_tty_register_driver(struct tty_driver *driver) {};
> -static inline void proc_tty_unregister_driver(struct tty_driver *driver) {};
> -
>  #endif /* CONFIG_PROC_FS */
>  
>  
> @@ -187,7 +153,4 @@ static inline void *PDE_DATA(const struct inode *inode)
>  	return PROC_I(inode)->pde->data;
>  }
>  
> -#include <linux/signal.h>
> -
> -void render_sigset_t(struct seq_file *m, const char *header, sigset_t *set);
>  #endif /* _LINUX_PROC_FS_H */
> diff --git a/include/linux/signal.h b/include/linux/signal.h
> index a2dcb94..1135e36 100644
> --- a/include/linux/signal.h
> +++ b/include/linux/signal.h
> @@ -434,4 +434,9 @@ void signals_init(void);
>  int restore_altstack(const stack_t __user *);
>  int __save_altstack(stack_t __user *, unsigned long);
>  
> +#ifdef CONFIG_PROC_FS
> +struct seq_file;
> +extern void render_sigset_t(struct seq_file *, const char *, sigset_t *);
> +#endif
> +
>  #endif /* _LINUX_SIGNAL_H */
> diff --git a/include/linux/tty.h b/include/linux/tty.h
> index c75d886..e34605b 100644
> --- a/include/linux/tty.h
> +++ b/include/linux/tty.h
> @@ -658,5 +658,12 @@ do {									\
>  	finish_wait(&wq, &__wait);					\
>  } while (0)
>  
> +#ifdef CONFIG_PROC_FS
> +extern void proc_tty_register_driver(struct tty_driver *);
> +extern void proc_tty_unregister_driver(struct tty_driver *);
> +#else
> +static inline void proc_tty_register_driver(struct tty_driver *) {}
> +static inline void proc_tty_unregister_driver(struct tty_driver *) {}
> +#endif
>  
>  #endif
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
