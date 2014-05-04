Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaEDA2u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 20:28:50 -0400
Received: from mail.siteground.com ([67.19.240.234]:44721 "EHLO
	mail.siteground.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbaEDA2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 20:28:49 -0400
Message-ID: <536589B5.8060900@1h.com>
Date: Sun, 04 May 2014 03:28:37 +0300
From: Marian Marinov <mm@1h.com>
Organization: 1H Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: akpm@linux-foundation.org, n-horiguchi@ah.jp.nec.com,
        Greg KH <gregkh@linuxfoundation.org>, manfred@colorfullife.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] IPC initialize shmmax and shmall from the current value
 not the default
References: <5365723D.7030303@1h.com> <1399161216.2573.9.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1399161216.2573.9.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - mail.siteground.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - 1h.com
X-Get-Message-Sender-Via: mail.siteground.com: none
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2014 02:53 AM, Davidlohr Bueso wrote:
> On Sun, 2014-05-04 at 01:48 +0300, Marian Marinov wrote:
>> When we are creating new IPC namespace that should be cloned from the current namespace it is a good idea to copy the
>> values of the current shmmax and shmall to the new namespace.
>
> Why is this a good idea?
>
> This would break userspace that relies on the current behavior.
> Furthermore we've recently changed the default value of both these
> limits to be as large as you can get, thus deprecating them. I don't
> like the idea of this being replaced by namespaces.
>
> Thanks,
> Davidlohr
>

The current behavior is create_ipc_ns()->shm_init_ns()

void shm_init_ns(struct ipc_namespace *ns)
{
     ns->shm_ctlmax = SHMMAX;
     ns->shm_ctlall = SHMALL;
     ns->shm_ctlmni = SHMMNI;
     ns->shm_rmid_forced = 0;
     ns->shm_tot = 0;
     ipc_init_ids(&shm_ids(ns));
}

This means that whenever you are creating an IPC namespace it gets its SHMMAX and SHMALL values from the defaults for 
the kernel.
If for some reason you want to have smaller(or bigger, for older kernels) limit. This means changing the values in 
/proc/sys/kernel/shmmax and /proc/sys/kernel/shmall. However the program that is started with the new IPC namespace may 
lack privileges to write to these files and so it can not modify them.

What I'm proposing is simply to copy the current values of the host machine, as set by a privileged process before the 
namespace creation.

Maybe a better approach would be to allow the changes to be done by processes having CAP_SYS_RESOURCE inside the new 
namespace?

Marian

-- 
Marian Marinov
Founder & CEO of 1H Ltd.
Jabber/GTalk: hackman@jabber.org
ICQ: 7556201
Mobile: +359 886 660 270
