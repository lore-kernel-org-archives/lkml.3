Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbaJGQhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:37:33 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9319 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbaJGQhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:37:31 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-f6-543416c88003
From: Krzysztof Opasiak <k.opasiak@samsung.com>
To: balbi@ti.com
Cc: "'Robert Baldyga'" <r.baldyga@samsung.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        mina86@mina86.com, andrzej.p@samsung.com
References: <1412594714-535-1-git-send-email-r.baldyga@samsung.com>
 <20141007022851.GA13956@saruman> <5433892C.80109@samsung.com>
 <20141007140656.GB24720@saruman>
 <0a2301cfe23f$8b4a40b0$a1dec210$%opasiak@samsung.com>
 <20141007152822.GO24720@saruman>
In-reply-to: <20141007152822.GO24720@saruman>
Subject: RE: [PATCH] usb: gadget: f_fs: add "zombie" mode
Date: Tue, 07 Oct 2014 18:37:26 +0200
Message-id: <0a3e01cfe24c$fb865370$f292fa50$%opasiak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/iQ1tUWlvSZRk7RDKx/BPh6Xb7LwABw7bg
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsVy+t/xa7onxExCDL4381vMetnOYnHwfr1F
	8+L1bBaXd81hs1i0rJXZYsHxFlaLB4d3sjuwe+yfu4bdY92fV0wefVtWMXocv7GdyePzJrkA
	1igum5TUnMyy1CJ9uwSujFkv/7AU7DGpOD99KnsD40mNLkZODgkBE4nDO7YyQ9hiEhfurWfr
	YuTiEBJYyijR/O88M4TTwCRxenEvaxcjBwebgL7EvF2iIA0iAgIS619cYgepYRZYzyhx5+9F
	FoiGRiaJnfOvgI3lFNCVONhyhxXEFhawlPi+5DwbiM0ioCqx+mk/C4jNK+Ao8f7ac0YIW1Di
	x+R7YHFmAS2J9TuPM0HY8hKb17xlBjlCQkBd4tFfXRBTRMBIYsJcf4gKEYm7Dc9ZJzAKzUIy
	aBaSQbOQDJqFpGUBI8sqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJBY+bKDcfExq0OMAhyM
	Sjy8GwyNQ4RYE8uKK3MPMUpwMCuJ8E7lNAkR4k1JrKxKLcqPLyrNSS0+xMjEwSnVwBhoL/9S
	23qK6ex7E+Zk/UuUuMMzU/9rfuvOtbduKuo9239phmCJeepi8U3/+NL/fNNdfl9A+FK69gzN
	XTcmrLJZndy9s0pFqCl3wrc+hYnxPx0/Mv2JNHuSljblaUJqv7s266TuTzwzfR9z5yicrjpr
	OfeDlaqIVvWNdZyMPldrJq4/M7eoTVKJpTgj0VCLuag4EQDI8D98cwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Tuesday, October 07, 2014 5:28 PM
> To: Krzysztof Opasiak
> Cc: balbi@ti.com; 'Robert Baldyga'; gregkh@linuxfoundation.org;
> linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org;
> mina86@mina86.com; andrzej.p@samsung.com
> Subject: Re: [PATCH] usb: gadget: f_fs: add "zombie" mode
> 
> Hi,
> 
> On Tue, Oct 07, 2014 at 05:01:15PM +0200, Krzysztof Opasiak wrote:
> > > > > Hi,
> > > > >
> > > > > On Mon, Oct 06, 2014 at 01:25:14PM +0200, Robert Baldyga
> wrote:
> > > > >> Since we can compose gadgets from many functions, there is
> the
> > > > >> problem related to gadget breakage while FunctionFS daemon
> > > being
> > > > >> closed. In some cases it's strongly desired to keep gadget
> > > alive
> > > > >> for a while, despite FunctionFS files are closed, to allow
> > > another
> > > > >> functions to complete some presumably critical operations.
> > > > >>
> > > > >> For this purpose this patch introduces "zombie" mode. It
> can
> > > be
> > > > >> enabled by setting mount option "zombie=1", and results
> with
> > > > >> defering function closure to the moment of reopening ep0
> file
> > > or filesystem umount.
> > > > >>
> > > > >> When ffs->state == FFS_ZOMBIE:
> > > > >> - function is still binded and visible to host,
> > > > >> - setup requests are automatically stalled,
> > > > >> - all another transfers are refused,
> > > > >> - opening ep0 causes function close, and then FunctionFS
> is
> > > ready for
> > > > >>   descriptors and string write,
> > > > >> - umount of functionfs cause function close.
> > > > >>
> > > > >> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> > > > >
> > > > > Can you further explain how do you trigger this ? Do I
> > > understand
> > > > > correctly that you composed a gadget using configfs and
> that
> > > gadget
> > > > > has functionfs + another gadget ?
> > > > >
> > > >
> > > > Yes, I compose configfs gadget from functionfs + another
> gadget,
> > > and
> > > > when functionfs daemon closes ep files, entire gadget get
> > > disconnected
> > > > from host. FFS function is userspace code so there is no way
> to
> > > know
> > > > when it will close files (it doesn't matter what is the
> reason of
> > > this
> > > > situation, it can be daemon logic, program breakage, process
> kill
> > > or
> > > > any other). So when we have another function in gadget which,
> for
> > > > example, sends some amount of data, does some software update
> or
> > > > implements some real-time functionality, we may want to keep
> the
> > > > gadget connected despite FFS function is no longer
> functional. We
> > > > can't just remove one of functions from gadget since it has
> been
> > > > enumerated, so the only way we can do that is to make broken
> FFS
> > > > function "zombie". It will be still visible to host but it
> will
> > > no longer implement it's functionality.
> > >
> > > now that's an explanation. Can you update commit log with some
> of
> > > this info (once we agree on how to go about fixing this) ?
> > >
> > > I'm not sure we should try to fix this. The only case where
> this
> > > could trigger is if ffs daemon crashes and dies or somebody
> sends a
> > > bogus signal to kill it.
> > >
> > > A function cannot communicate with the host if it isn't
> functional
> > > and ffs depends on its userland daemon. If daemon is crashing,
> why
> > > not print a big WARN("closed %s while connected to host\n") ?
> That
> > > seems like it's as much as we can do from the kernel. Userland
> > > should know that they can't have a buggy ffs daemon.
> >
> > It's not a problem of buggy ffs daemon. The problem is that there
> are
> > some non deterministic mechanisms in userspace like OOM killer.
> FFS
> > daemon can be written very well but if we are out of memory it
> may
> > become a victim. In this case reliability of whole gadget hurts a
> lot.
> >
> > If it's going about WARN(). I'm not enthusiastic about it.
> Userspace
> > process dies all the time, that's quite normal;) I don't think
> that it
> > is good idea to generate a warning on kernel level when some
> process
> > dies. Kernel should be resistant for such situations and know how
> to
> > deal with them (maybe user could select exact behavior, but it
> should
> > be done on kernel site)
> 
> yeah, and the way to deal with that is disconnecting from the host
> because that USB function, can't be functional anymore. I mean,
> imagine you try to e.g. unload pictures from your nice DSLR and
> that DSLR runs Linux and implements MTP or PTP using FFS. Then ptpd
> dies and you're still connected to the host so you can't know that
> something went wrong, the camera just stoped sending you data. So
> you figure: well, it must just be slow, I'll leave it here and go
> have a nap. Hours later and nothing has changed, because ptpd is
> still missing.
> 
> If you disconnect from the host, however, user knows
> instantaneously that something went wrong.

Please believe me that I totally agree with you, but I also see Robert's
point. Let's take ADB as example. Before ADB has been ported to
FunctionFS it communicated with kernel using dev node provided by ADB
function driver. With that infrastructure death of daemon didn't cause
gadget unbind because kernel driver of that function was just stalling
the endpoints. This allows user to use all other functions of this
gadget. In current design ADB uses FunctionFS and for example if daemon
will be killed by OOM whole gadget get's unbind and user cannot use any
other function. Don't you think that's a bit of regression?

I see and understand yours and Roberts point of view. Personally I'm not
too enthusiastic about using this solution but I see some rationales for
this and use cases. Summing it up, this patch may be useful in some
case. Let's allow end user to decide whether to use this mode or not. I
think that a few people will find this useful.

> 
> I don't think maintaining a "zombie" function is very nice. In
> fact, the very reason for adding usb_function_activate/deactivate
> was exactly to prevent us from ever connecting to a host with a
> non-working function.

Here also I agree. Zombie mode should "mock" the function until first
next enumeration or unbind. It should not be possible to bind gadget
with function in zombie mode to UDC. Zombie mode should "pretend" only
as long as gadget is bound and enumerated.


-- 
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
k.opasiak@samsung.com




