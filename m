Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaCLKcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:32:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62768 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbaCLKci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:32:38 -0400
X-IronPort-AV: E=Sophos;i="4.97,636,1389715200"; 
   d="scan'208";a="9683603"
Message-ID: <53202BE6.5030006@cn.fujitsu.com>
Date: Wed, 12 Mar 2014 17:41:58 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, joe@perches.com,
        mingo@kernel.org, tglx@linutronix.de, heiko.carstens@de.ibm.com
Subject: Re: [PATCH 08/17] ioprio: Add a macro named NICE_TO_IOPRIO.
References: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com> <73b55557223c09b0feb0979ac66340d162117555.1394532288.git.yangds.fnst@cn.fujitsu.com>
In-Reply-To: <73b55557223c09b0feb0979ac66340d162117555.1394532288.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/12 17:41:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/12 17:41:58,
	Serialize complete at 2014/03/12 17:41:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 06:09 PM, Dongsheng Yang wrote:
> As the task nice value is in [-20, 19] and the io priority is in [0, 7],
> and the convert method from niceval to ioprio is implemented with an
> opened code in task_nice_ioprio().
>
> This patch move the implementation to a macro NICE_TO_IOPRIO, making
> it more readable and modular.
>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>   include/linux/ioprio.h | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
> index beb9ce1..c0faa0b 100644
> --- a/include/linux/ioprio.h
> +++ b/include/linux/ioprio.h
> @@ -18,6 +18,11 @@
>   #define ioprio_valid(mask)	(IOPRIO_PRIO_CLASS((mask)) != IOPRIO_CLASS_NONE)
>   
>   /*
> + * Convert the nice value [19,-20] to io priority value [0,7].
> + */
> +#define NICE_TO_IOPRIO(nice)	(nice_to_rlimit(nice) / 5)
> +

Hi Peter,
     As you asked, why I added this macro in ioprio.h? And why it is better?

     IMO, there is a policy to convert a nice value to io priority, that 
divide the nice
range into 8 parts by 5. I think this is a common requirement for lots 
of io subsystem.
So I implement this policy with NICE_TO_IOPRIO.

     About function task_nice_iopiro(), it is to get the iopriority of a 
task. It should get the
nice value at first and then use the NICE_TO_IOPRIO to convert it to 
ioprio in the policy.

When our policy changed, we need only update the center controller, 
NICE_TO_IOPRIO.
Keep the others work well.

This is my point about this patch. I wish it explained better. Thanx.
> +/*
>    * These are the io priority groups as implemented by CFQ. RT is the realtime
>    * class, it always gets premium service. BE is the best-effort scheduling
>    * class, the default for any process. IDLE is the idle scheduling class, it
> @@ -52,7 +57,7 @@ enum {
>    */
>   static inline int task_nice_ioprio(struct task_struct *task)
>   {
> -	return (task_nice(task) + 20) / 5;
> +	return NICE_TO_IOPRIO(task_nice(task));
>   }
>   
>   /*

