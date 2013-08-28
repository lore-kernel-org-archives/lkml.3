Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab3H1Q5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 12:57:16 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:22695 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab3H1Q5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 12:57:13 -0400
Message-ID: <1377708941.10300.855.camel@misato.fc.hp.com>
Subject: Re: [PATCH] driver core / ACPI: Avoid device removal locking
 problems
From: Toshi Kani <toshi.kani@hp.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Date: Wed, 28 Aug 2013 10:55:41 -0600
In-Reply-To: <521D5C80.7010904@cn.fujitsu.com>
References: <1543475.L7gSB7lLAu@vostro.rjw.lan>
	  <4785337.sqQqDSPcpL@vostro.rjw.lan> <3389643.Fdir3g6c6B@vostro.rjw.lan>
	  <1430120.G7JdUKlgj6@vostro.rjw.lan> <521C6FA8.4070804@cn.fujitsu.com>
	 <1377639529.10300.847.camel@misato.fc.hp.com>
	 <521D5C80.7010904@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-28 at 10:12 +0800, Gu Zheng wrote:
> On 08/28/2013 05:38 AM, Toshi Kani wrote:
 :
> >>
> >> What about changing device_hotplug_lock and acpi_scan_lock to rwsem? like the
> >> attached one(With a preliminary test, it also can make the splat go away).:)
> > 
> > I am curious how msleep(10) & restart_syscall() work in the change
> > below.  Doesn't the msleep() make s_active held longer time, which can
> > lead the thread holding device_hotplug_lock to wait it for deletion?
> 
> Yes, but it can avoid busy waiting. 

I know, but it's kinda unfortunate to sleep with s_active held in this
situation.  But I am fine with the 5ms Rafael used in this latest
patchset since this is a rare case anyway.

> > Also, does restart_syscall() release s_active and reopen this file
> > again?
> 
> Sure, it just set a TIF_SIGPENDING flag and return an -ERESTARTNOINTR error, s_active/file
> will be released/closed in the failed path. And when do_signal() catches the -ERESTARTNOINTR,
> it will change the regs to restart the syscall.

I see.  This is a clever functionality. 

Thanks,
-Toshi


