Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaLISVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 13:21:34 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:64944 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaLISVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 13:21:32 -0500
MIME-Version: 1.0
In-Reply-To: <20141209075619.GA23327@richard>
References: <1418075552-26495-1-git-send-email-yinghai@kernel.org>
 <1418079372.13358.9.camel@kernel.crashing.org> <CAE9FiQX-vMu5+Kr09ngr95WvtoZTUSL5R2+NiVFeiN6q-BXLLg@mail.gmail.com>
 <20141209001119.GA24661@shangw> <20141209022601.GA16207@richard>
 <CAE9FiQWz=vdR=QSkoEs5XjUxg_y4vJgnChQAc1-U_9xzfQpknQ@mail.gmail.com> <20141209075619.GA23327@richard>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 9 Dec 2014 11:21:11 -0700
Message-ID: <CAErSpo5Wj1GScsj6=_=Vv73NSh3D-SCfhEdeK6VOY1AicVUN3Q@mail.gmail.com>
Subject: Re: [PATCH] PCI: Clear bridge MEM_64 flag if one child does not
 support it
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        =?UTF-8?Q?Marek_Kord=C3=ADk?= <kordikmarek@gmail.com>,
        Alexey Voronkov <zermond@gmail.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 12:56 AM, Wei Yang <weiyang@linux.vnet.ibm.com> wrote:

> As you mentioned in another thread, "5b28541552ef is taking the wrong
> approach". (http://www.spinics.net/lists/linux-pci/msg37374.html) Maybe I
> don't catch it clearly. Put a 32bit prefetchable resource in a 32bit
> non-prefetchable bridge window is a bad idea?

A 32-bit prefetchable resource *can* be put in a 32-bit
non-prefetchable window, but the device won't perform as well as it
would if the resource were in a prefetchable window.

What I object to is the fact that we put a 32-bit prefetchable
resource in the non-prefetchable window and leave the 64-bit
prefetchable window unused.  This gives up performance for no benefit.

> But in my mind, if the bridge
> prefetchable window is 64bit, we can't put a 32bit prefetchable resource in
> it.

If the window is programmed to be above 4GB, of course we can't put a
32-bit resource in it.  My point is that if the bridge *supports* a
64-bit prefetchable window, we can decide where to place it.  If we
put the window below 4GB, we can put a 32-bit prefetchable resource in
it.

I think maybe you're thinking of "64-bit window" as "a window
programmed to be above 4GB."  I'm using "64-bit window" to mean "a
window that supports 64-bit addressing," i.e., one where
PCI_PREF_BASE_UPPER32 and PCI_PREF_LIMIT_UPPER32 are implemented.
That's analogous to the way we talk about 64-bit BARs.  A 64-bit BAR
is still a 64-bit BAR even if it is currently programmed to be below
4GB.

Bjorn
