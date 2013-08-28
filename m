Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3H1CQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 22:16:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3971 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab3H1CQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 22:16:43 -0400
X-IronPort-AV: E=Sophos;i="4.89,972,1367942400"; 
   d="scan'208";a="8325720"
Message-ID: <521D5C80.7010904@cn.fujitsu.com>
Date: Wed, 28 Aug 2013 10:12:16 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] driver core / ACPI: Avoid device removal locking problems
References: <1543475.L7gSB7lLAu@vostro.rjw.lan>  <4785337.sqQqDSPcpL@vostro.rjw.lan> <3389643.Fdir3g6c6B@vostro.rjw.lan>  <1430120.G7JdUKlgj6@vostro.rjw.lan> <521C6FA8.4070804@cn.fujitsu.com> <1377639529.10300.847.camel@misato.fc.hp.com>
In-Reply-To: <1377639529.10300.847.camel@misato.fc.hp.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/28 10:14:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/28 10:14:44,
	Serialize complete at 2013/08/28 10:14:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toshi,

On 08/28/2013 05:38 AM, Toshi Kani wrote:

> On Tue, 2013-08-27 at 17:21 +0800, Gu Zheng wrote:
>> Hi Rafael,
>>
>> On 08/26/2013 11:02 PM, Rafael J. Wysocki wrote:
>>
>>> On Monday, August 26, 2013 04:43:26 PM Rafael J. Wysocki wrote:
>>>> On Monday, August 26, 2013 02:42:09 PM Rafael J. Wysocki wrote:
>>>>> On Monday, August 26, 2013 11:13:13 AM Gu Zheng wrote:
>>>>>> Hi Rafael,
>>>
>>> [...]
>>>
>>>>
>>>> OK, so the patch below is quick and dirty and overkill, but it should make the
>>>> splat go away at least.
>>>
>>> And if this patch does make the splat go away for you, please also test the
>>> appended one (Tejun, thanks for the hint!).
>>>
>>> I'll address the ACPI part differently later.
>>
>> What about changing device_hotplug_lock and acpi_scan_lock to rwsem? like the
>> attached one(With a preliminary test, it also can make the splat go away).:)
> 
> I am curious how msleep(10) & restart_syscall() work in the change
> below.  Doesn't the msleep() make s_active held longer time, which can
> lead the thread holding device_hotplug_lock to wait it for deletion?

Yes, but it can avoid busy waiting. 

> Also, does restart_syscall() release s_active and reopen this file
> again?

Sure, it just set a TIF_SIGPENDING flag and return an -ERESTARTNOINTR error, s_active/file
will be released/closed in the failed path. And when do_signal() catches the -ERESTARTNOINTR,
it will change the regs to restart the syscall.

Thanks,
Gu

> 
> @@ -408,9 +408,13 @@ static ssize_t show_online(struct device *dev,
> struct device_attribute *attr,
>  {
>         bool val;
> 
> -       lock_device_hotplug();
> +       if (!read_lock_device_hotplug()) {
> +               msleep(10);
> +               return restart_syscall();
> +       }
> +
> 
> Thanks,
> -Toshi
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


