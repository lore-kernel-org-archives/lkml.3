Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082Ab3EGQ2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 12:28:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758846Ab3EGQ2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 12:28:14 -0400
Date: Tue, 7 May 2013 12:27:39 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] kmsg: honor dmesg_restrict sysctl on /dev/kmsg
Message-ID: <20130507162738.GC16269@hansolo.jdub.homelinux.org>
References: <20130430172541.GA23382@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130430172541.GA23382@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 10:25:41AM -0700, Kees Cook wrote:
> To fix /dev/kmsg, let's compare the existing interfaces and what they allow:
> 
> - /proc/kmsg allows:
>  - open (SYSLOG_ACTION_OPEN) if CAP_SYSLOG since it uses a destructive
>    single-reader interface (SYSLOG_ACTION_READ).
>  - everything, after an open.
> 
> - syslog syscall allows:
>  - anything, if CAP_SYSLOG.
>  - SYSLOG_ACTION_READ_ALL and SYSLOG_ACTION_SIZE_BUFFER, if dmesg_restrict==0.
>  - nothing else (EPERM).
> 
> The use-cases were:
> - dmesg(1) needs to do non-destructive SYSLOG_ACTION_READ_ALLs.
> - sysklog(1) needs to open /proc/kmsg, drop privs, and still issue the
>   destructive SYSLOG_ACTION_READs.
> 
> AIUI, dmesg(1) is moving to /dev/kmsg, and systemd-journald doesn't
> clear the ring buffer.
> 
> Based on the comments in devkmsg_llseek, it sounds like actions besides
> reading aren't going to be supported by /dev/kmsg (i.e. SYSLOG_ACTION_CLEAR),
> so we have a strict subset of the non-destructive syslog syscall actions.
> 
> To this end, move the check as Josh had done, but also rename the constants
> to reflect their new uses (SYSLOG_FROM_CALL becomes SYSLOG_FROM_READER, and
> SYSLOG_FROM_FILE becomes SYSLOG_FROM_PROC). SYSLOG_FROM_READER allows
> non-destructive actions, and SYSLOG_FROM_PROC allows destructive actions
> after a capabilities-constrained SYSLOG_ACTION_OPEN check.
> 
> - /dev/kmsg allows:
>  - open if CAP_SYSLOG or dmesg_restrict==0
>  - reading/polling, after open
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Reported-by: Christian Kujau <lists@nerdbynature.de>
> Cc: Josh Boyer <jwboyer@redhat.com>
> Cc: Kay Sievers <kay@vrfy.org>
> Cc: stable@vger.kernel.org

OK, this seems to work as expected.  Non-privileged users can open
/dev/kmsg for reading and read dmesg if dmesg_restrict is not set.  If
set, dmesg(1) will try both /dev/kmsg and the syslog call and get EPERM
back.  Running as root still works.

Tested-by: Josh Boyer <jwboyer@redhat.com>

> ---
>  fs/proc/kmsg.c         |   10 +++---
>  include/linux/syslog.h |    4 +--
>  kernel/printk.c        |   91 ++++++++++++++++++++++++++----------------------
>  3 files changed, 57 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/proc/kmsg.c b/fs/proc/kmsg.c
> index bd4b5a7..bdfabda 100644
> --- a/fs/proc/kmsg.c
> +++ b/fs/proc/kmsg.c
> @@ -21,12 +21,12 @@ extern wait_queue_head_t log_wait;
>  
>  static int kmsg_open(struct inode * inode, struct file * file)
>  {
> -	return do_syslog(SYSLOG_ACTION_OPEN, NULL, 0, SYSLOG_FROM_FILE);
> +	return do_syslog(SYSLOG_ACTION_OPEN, NULL, 0, SYSLOG_FROM_PROC);
>  }
>  
>  static int kmsg_release(struct inode * inode, struct file * file)
>  {
> -	(void) do_syslog(SYSLOG_ACTION_CLOSE, NULL, 0, SYSLOG_FROM_FILE);
> +	(void) do_syslog(SYSLOG_ACTION_CLOSE, NULL, 0, SYSLOG_FROM_PROC);
>  	return 0;
>  }
>  
> @@ -34,15 +34,15 @@ static ssize_t kmsg_read(struct file *file, char __user *buf,
>  			 size_t count, loff_t *ppos)
>  {
>  	if ((file->f_flags & O_NONBLOCK) &&
> -	    !do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_FILE))
> +	    !do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_PROC))
>  		return -EAGAIN;
> -	return do_syslog(SYSLOG_ACTION_READ, buf, count, SYSLOG_FROM_FILE);
> +	return do_syslog(SYSLOG_ACTION_READ, buf, count, SYSLOG_FROM_PROC);
>  }
>  
>  static unsigned int kmsg_poll(struct file *file, poll_table *wait)
>  {
>  	poll_wait(file, &log_wait, wait);
> -	if (do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_FILE))
> +	if (do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_PROC))
>  		return POLLIN | POLLRDNORM;
>  	return 0;
>  }
> diff --git a/include/linux/syslog.h b/include/linux/syslog.h
> index 3891139..98a3153 100644
> --- a/include/linux/syslog.h
> +++ b/include/linux/syslog.h
> @@ -44,8 +44,8 @@
>  /* Return size of the log buffer */
>  #define SYSLOG_ACTION_SIZE_BUFFER   10
>  
> -#define SYSLOG_FROM_CALL 0
> -#define SYSLOG_FROM_FILE 1
> +#define SYSLOG_FROM_READER           0
> +#define SYSLOG_FROM_PROC             1
>  
>  int do_syslog(int type, char __user *buf, int count, bool from_file);
>  
> diff --git a/kernel/printk.c b/kernel/printk.c
> index abbdd9e..53b5c5e 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -368,6 +368,53 @@ static void log_store(int facility, int level,
>  	log_next_seq++;
>  }
>  
> +#ifdef CONFIG_SECURITY_DMESG_RESTRICT
> +int dmesg_restrict = 1;
> +#else
> +int dmesg_restrict;
> +#endif
> +
> +static int syslog_action_restricted(int type)
> +{
> +	if (dmesg_restrict)
> +		return 1;
> +	/*
> +	 * Unless restricted, we allow "read all" and "get buffer size"
> +	 * for everybody.
> +	 */
> +	return type != SYSLOG_ACTION_READ_ALL &&
> +	       type != SYSLOG_ACTION_SIZE_BUFFER;
> +}
> +
> +static int check_syslog_permissions(int type, bool from_file)
> +{
> +	/*
> +	 * If this is from /proc/kmsg and we've already opened it, then we've
> +	 * already done the capabilities checks at open time.
> +	 */
> +	if (from_file && type != SYSLOG_ACTION_OPEN)
> +		return 0;
> +
> +	if (syslog_action_restricted(type)) {
> +		if (capable(CAP_SYSLOG))
> +			return 0;
> +		/*
> +		 * For historical reasons, accept CAP_SYS_ADMIN too, with
> +		 * a warning.
> +		 */
> +		if (capable(CAP_SYS_ADMIN)) {
> +			printk_once(KERN_WARNING "%s (%d): "
> +				 "Attempt to access syslog with CAP_SYS_ADMIN "
> +				 "but no CAP_SYSLOG (deprecated).\n",
> +				 current->comm, task_pid_nr(current));
> +			return 0;
> +		}
> +		return -EPERM;
> +	}
> +	return security_syslog(type);
> +}
> +
> +
>  /* /dev/kmsg - userspace message inject/listen interface */
>  struct devkmsg_user {
>  	u64 seq;
> @@ -624,7 +671,8 @@ static int devkmsg_open(struct inode *inode, struct file *file)
>  	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
>  		return 0;
>  
> -	err = security_syslog(SYSLOG_ACTION_READ_ALL);
> +	err = check_syslog_permissions(SYSLOG_ACTION_READ_ALL,
> +				       SYSLOG_FROM_READER);
>  	if (err)
>  		return err;
>  
> @@ -817,45 +865,6 @@ static inline void boot_delay_msec(int level)
>  }
>  #endif
>  
> -#ifdef CONFIG_SECURITY_DMESG_RESTRICT
> -int dmesg_restrict = 1;
> -#else
> -int dmesg_restrict;
> -#endif
> -
> -static int syslog_action_restricted(int type)
> -{
> -	if (dmesg_restrict)
> -		return 1;
> -	/* Unless restricted, we allow "read all" and "get buffer size" for everybody */
> -	return type != SYSLOG_ACTION_READ_ALL && type != SYSLOG_ACTION_SIZE_BUFFER;
> -}
> -
> -static int check_syslog_permissions(int type, bool from_file)
> -{
> -	/*
> -	 * If this is from /proc/kmsg and we've already opened it, then we've
> -	 * already done the capabilities checks at open time.
> -	 */
> -	if (from_file && type != SYSLOG_ACTION_OPEN)
> -		return 0;
> -
> -	if (syslog_action_restricted(type)) {
> -		if (capable(CAP_SYSLOG))
> -			return 0;
> -		/* For historical reasons, accept CAP_SYS_ADMIN too, with a warning */
> -		if (capable(CAP_SYS_ADMIN)) {
> -			printk_once(KERN_WARNING "%s (%d): "
> -				 "Attempt to access syslog with CAP_SYS_ADMIN "
> -				 "but no CAP_SYSLOG (deprecated).\n",
> -				 current->comm, task_pid_nr(current));
> -			return 0;
> -		}
> -		return -EPERM;
> -	}
> -	return 0;
> -}
> -
>  #if defined(CONFIG_PRINTK_TIME)
>  static bool printk_time = 1;
>  #else
> @@ -1253,7 +1262,7 @@ out:
>  
>  SYSCALL_DEFINE3(syslog, int, type, char __user *, buf, int, len)
>  {
> -	return do_syslog(type, buf, len, SYSLOG_FROM_CALL);
> +	return do_syslog(type, buf, len, SYSLOG_FROM_READER);
>  }
>  
>  /*
> -- 
> 1.7.9.5
> 
> 
> -- 
> Kees Cook
> Chrome OS Security
