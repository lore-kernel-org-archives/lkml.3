Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaJGPBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:01:24 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22060 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbaJGPBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:01:22 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-82-5434003c42fa
From: Krzysztof Opasiak <k.opasiak@samsung.com>
To: balbi@ti.com, "'Robert Baldyga'" <r.baldyga@samsung.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com, andrzej.p@samsung.com
References: <1412594714-535-1-git-send-email-r.baldyga@samsung.com>
 <20141007022851.GA13956@saruman> <5433892C.80109@samsung.com>
 <20141007140656.GB24720@saruman>
In-reply-to: <20141007140656.GB24720@saruman>
Subject: RE: [PATCH] usb: gadget: f_fs: add "zombie" mode
Date: Tue, 07 Oct 2014 17:01:15 +0200
Message-id: <0a2301cfe23f$8b4a40b0$a1dec210$%opasiak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/iN/lCkoZERrkDSOi5zeaqJffB/wABW9SA
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/xK7o2DCYhBk8/K1jMetnOYnHwfr1F
	8+L1bBaXd81hs1i0rJXZYsHxFlaLB4d3sjuwe+yfu4bdY92fV0wefVtWMXocv7GdyePzJrkA
	1igum5TUnMyy1CJ9uwSujL4di9gKPilUrHuym7WB8a9kFyMnh4SAicSXk0vZIGwxiQv31gPZ
	XBxCAksZJd6ensUCkhASaGCS2LvGr4uRg4NNQF9i3i5REFNEwEqie7I4SAWzQDOjxJxFfBCt
	yxglTt88BtbKKaArcX3aCkYQW1jAUuL7kvNgu1gEVCX2LtrBDDKHV8BR4ufmAJAwr4CgxI/J
	91ggZmpJrN95nAnClpfYvOYtWLmEgLrEo7+6IGERASOJI5P/MUOUiEjcbXjOOoFRaBaSSbOQ
	TJqFZNIsJC0LGFlWMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoREyZcdjIuPWR1iFOBgVOLh
	3WBoHCLEmlhWXJl7iFGCg1lJhHfKe6AQb0piZVVqUX58UWlOavEhRiYOTqkGxhAjZh0tiRn3
	TEU4z/k//s3WZn+8LPT9Havl+WINndNXF55YW+f/zqk4ch/bHGnb7Rml7BoGC2+sWPZx+067
	rXXlH4Xbm8yEvGP0lumLiWw4Vban9uGmVVdPnvRy3vRLrX+XZtorFYkA/dmPH7NnVDjNMXkw
	6wtPUMsMWxXdbZNWnYgTk78rpcRSnJFoqMVcVJwIALW/kzRwAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Tuesday, October 07, 2014 4:07 PM
> To: Robert Baldyga
> Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-
> usb@vger.kernel.org; linux-kernel@vger.kernel.org;
> mina86@mina86.com; andrzej.p@samsung.com; k.opasiak@samsung.com
> Subject: Re: [PATCH] usb: gadget: f_fs: add "zombie" mode
> 
> Hi,
> 
> On Tue, Oct 07, 2014 at 08:33:16AM +0200, Robert Baldyga wrote:
> > On 10/07/2014 04:28 AM, Felipe Balbi wrote:
> > > Hi,
> > >
> > > On Mon, Oct 06, 2014 at 01:25:14PM +0200, Robert Baldyga wrote:
> > >> Since we can compose gadgets from many functions, there is the
> > >> problem related to gadget breakage while FunctionFS daemon
> being
> > >> closed. In some cases it's strongly desired to keep gadget
> alive
> > >> for a while, despite FunctionFS files are closed, to allow
> another
> > >> functions to complete some presumably critical operations.
> > >>
> > >> For this purpose this patch introduces "zombie" mode. It can
> be
> > >> enabled by setting mount option "zombie=1", and results with
> > >> defering function closure to the moment of reopening ep0 file
> or filesystem umount.
> > >>
> > >> When ffs->state == FFS_ZOMBIE:
> > >> - function is still binded and visible to host,
> > >> - setup requests are automatically stalled,
> > >> - all another transfers are refused,
> > >> - opening ep0 causes function close, and then FunctionFS is
> ready for
> > >>   descriptors and string write,
> > >> - umount of functionfs cause function close.
> > >>
> > >> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> > >
> > > Can you further explain how do you trigger this ? Do I
> understand
> > > correctly that you composed a gadget using configfs and that
> gadget
> > > has functionfs + another gadget ?
> > >
> >
> > Yes, I compose configfs gadget from functionfs + another gadget,
> and
> > when functionfs daemon closes ep files, entire gadget get
> disconnected
> > from host. FFS function is userspace code so there is no way to
> know
> > when it will close files (it doesn't matter what is the reason of
> this
> > situation, it can be daemon logic, program breakage, process kill
> or
> > any other). So when we have another function in gadget which, for
> > example, sends some amount of data, does some software update or
> > implements some real-time functionality, we may want to keep the
> > gadget connected despite FFS function is no longer functional. We
> > can't just remove one of functions from gadget since it has been
> > enumerated, so the only way we can do that is to make broken FFS
> > function "zombie". It will be still visible to host but it will
> no longer implement it's functionality.
> 
> now that's an explanation. Can you update commit log with some of
> this info (once we agree on how to go about fixing this) ?
> 
> I'm not sure we should try to fix this. The only case where this
> could trigger is if ffs daemon crashes and dies or somebody sends a
> bogus signal to kill it.
> 
> A function cannot communicate with the host if it isn't functional
> and ffs depends on its userland daemon. If daemon is crashing, why
> not print a big WARN("closed %s while connected to host\n") ? That
> seems like it's as much as we can do from the kernel. Userland
> should know that they can't have a buggy ffs daemon.

It's not a problem of buggy ffs daemon. The problem is that there are
some non deterministic mechanisms in userspace like OOM killer. FFS
daemon can be written very well but if we are out of memory it may
become a victim. In this case reliability of whole gadget hurts a lot.

If it's going about WARN(). I'm not enthusiastic about it. Userspace
process dies all the time, that's quite normal;) I don't think that it
is good idea to generate a warning on kernel level when some process
dies. Kernel should be resistant for such situations and know how to
deal with them (maybe user could select exact behavior, but it should be
done on kernel site)

-- 
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
k.opasiak@samsung.com



