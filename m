Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab3AYUa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 15:30:59 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:60857 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab3AYUa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 15:30:57 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUP71TJgP21SRre4Mb2PrnUg+7KLzXnxHUviqCuNSL44w@mail.gmail.com>
References: <1356594177-29453-1-git-send-email-linfeng@cn.fujitsu.com>
 <CAErSpo7EmvDaK11P6r-PKxPBqHQBPaGvZj=zvNZ8w=KFbdFgYA@mail.gmail.com>
 <5102583E.4030109@cn.fujitsu.com> <CAErSpo58qUuwd+8bGMWQHQ6KrfQMvHGb+REVkpJqQdrfAQe3Qw@mail.gmail.com>
 <CAE9FiQUP71TJgP21SRre4Mb2PrnUg+7KLzXnxHUviqCuNSL44w@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 25 Jan 2013 13:30:36 -0700
Message-ID: <CAErSpo4_iz29b9Tj8W4D9YqdGPV4P+rFZ463eZ1S4J2gL_6qyw@mail.gmail.com>
Subject: Re: [PATCH] pci-sysfs: replace mutex_lock with mutex_trylock to avoid
 potential deadlock situation
To: Yinghai Lu <yinghai@kernel.org>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>, Lin Feng <linfeng@cn.fujitsu.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        tangchen@cn.fujitsu.com, laijs@cn.fujitsu.com, wency@cn.fujitsu.com,
        izumi.taku@jp.fujitsu.com, Don Dutile <ddutile@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 11:57 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Jan 25, 2013 at 9:44 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> [+cc Yinghai]
>>
>> On Fri, Jan 25, 2013 at 3:02 AM, Gu Zheng
>
> Hi, Gu,
>
> Can you check if two patches in
>
> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=shortlog;h=refs/heads/for-pci-root-bus-hotplug-part3
>
> could solve your problem?
>
> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=277df390baeab7ba6aa136356b677a096c890c0c
>
> PCI: Rescan bus using callback method too
>
>
> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=282e2db3b58d56b5236ee755e1527574df0d298e
>
> PCI, sysfs: Clean up rescan/remove with scheule_callback

You ignored and clipped my concerns about similar synchronization
issues outside sysfs, so let me quote it again here:

I'm sorry that you tripped over this deadlock, because now I'm worried
about related locking issues outside sysfs :)  The mutex you're
fiddling with is only in sysfs, but the routines *protected* by that
mutex are used in other places, too.  So what happens when a hotplug
driver does a rescan at the same time a user does a rescan or remove
via sysfs?  I don't even know what the rules are for protecting
scan/remove, but I don't have confidence that the issue you're fixing
is the only one.

If we're going to fix the sysfs deadlock (and we should), I want to
either see an argument for why we don't have a problem outside of
sysfs, or I want to fix sysfs and non-sysfs at the same time.

Bjorn
