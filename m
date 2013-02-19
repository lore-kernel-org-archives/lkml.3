Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab3BSCCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:02:19 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:54040 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758117Ab3BSCCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:02:15 -0500
Message-ID: <1361239316.3263.39.camel@thor.lan>
Subject: Page allocation failures  (was Re: WARNING: at
 drivers/gpu/drm/nouveau/core/core/mm.c:242)
From: Peter Hurley <peter@hurleysoftware.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, bskeggs@redhat.com,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Date: Mon, 18 Feb 2013 21:01:56 -0500
In-Reply-To: <5122BC8A.6040503@suse.cz>
References: <5122021F.1060207@suse.cz> <20130218232335.GA9730@joi.lan>
	 <5122BC8A.6040503@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-19 at 00:43 +0100, Jiri Slaby wrote:
> On 02/19/2013 12:23 AM, Marcin Slusarz wrote:
> > On Mon, Feb 18, 2013 at 11:27:43AM +0100, Jiri Slaby wrote:
> >> Hi,
> >>
> >> we have a report of WARNING from 3.7.6 in nouveau at
> >> drivers/gpu/drm/nouveau/core/core/mm.c:242 here:
> >> https://bugzilla.novell.com/show_bug.cgi?id=802347#c11
> >>
> >> There is an order 4 allocation failure in nouveau_drm_open ->
> >> nouveau_vm_create, i.e. this one failed:
> >> vm->pgt  = kcalloc(vm->lpde - vm->fpde + 1, sizeof(*vm->pgt), GFP_KERNEL);

Hi Jiri,

I had the order 4 allocation failure and nouveau crash back in November
on next-20121129. Bugzillas here:

Allocation failure:
https://bugzilla.kernel.org/show_bug.cgi?id=51301

Nouveau bug:
https://bugzilla.kernel.org/show_bug.cgi?id=51291
https://bugs.freedesktop.org/show_bug.cgi?id=58087

IMO, the 32k allocation failure is the more serious bug. Check out the
slab info from your report:

Feb 06 13:16:15 desdemona kernel: Node 0 DMA32: 13378*4kB 5026*8kB 1823*16kB
135*32kB 5*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 129576kB
Feb 06 13:16:15 desdemona kernel: Node 0 Normal: 1946*4kB 831*8kB 3*16kB 1*32kB
1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 16496kB

The pages are there: why did the allocation fail?

I think this is related to all that kswapd mess. In my case, the machine
really was OOM -- which made no sense. Completely out of page blocks
larger than 32k on a 10gb machine with a bunch of emacs and terminal
windows open for 3 days, just doing code, build, code, build, code,
build?

Regards,
Peter Hurley

