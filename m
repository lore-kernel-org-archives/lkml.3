Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbaBFSGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:06:15 -0500
Received: from relay.parallels.com ([195.214.232.42]:51095 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaBFSGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:06:13 -0500
Message-ID: <52F3CF12.70905@parallels.com>
Date: Thu, 6 Feb 2014 22:06:10 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <penberg@kernel.org>, <akpm@linux-foundation.org>, <rientjes@google.com>,
        <mhocko@suse.cz>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>
Subject: Re: [PATCH RFC] slub: do not drop slab_mutex for sysfs_slab_{add,remove}
References: <1391702294-27289-1-git-send-email-vdavydov@parallels.com> <alpine.DEB.2.10.1402061021180.4927@nuc>
In-Reply-To: <alpine.DEB.2.10.1402061021180.4927@nuc>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.24.25.245]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 08:22 PM, Christoph Lameter wrote:
> On Thu, 6 Feb 2014, Vladimir Davydov wrote:
>
>> When creating/destroying a kmem cache, we do a lot of work holding the
>> slab_mutex, but we drop it for sysfs_slab_{add,remove} for some reason.
>> Since __kmem_cache_create and __kmem_cache_shutdown are extremely rare,
>> I propose to simplify locking by calling sysfs_slab_{add,remove} w/o
>> dropping the slab_mutex.
> The problem is that sysfs does nasty things like spawning a process in
> user space that may lead to something wanting to create slabs too. The
> module may then hang waiting on the lock ...

Hmm... IIUC the only function of concern is kobject_uevent() -
everything else called from sysfs_slab_{add,remove} is a mix of kmalloc,
kfree, mutex_lock/unlock - in short, nothing dangerous. There we do
call_usermodehelper(), but we do it with UMH_WAIT_EXEC, which means
"wait for exec only, but not for the process to complete". An exec
shouldn't issue any slab-related stuff AFAIU. At least, I tried to run
the patched kernel with lockdep enabled and got no warnings at all when
getting uevents about adding/removing caches. That's why I started to
doubt whether we really need this lock...

Please correct me if I'm wrong.

> I would be very thankful, if you can get that actually working reliably
> without deadlock issues.

If there is no choice rather than moving sysfs_slab_{add,remove} out of
the slab_mutex critical section, I'll have to do it that way. But first
I'd like to make sure it cannot be done with less footprint.

Thanks.
