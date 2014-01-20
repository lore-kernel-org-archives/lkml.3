Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaATIjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:39:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaATIjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:39:08 -0500
Date: Mon, 20 Jan 2014 10:43:49 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: jasowang@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mtk.manpages@gmail.com, linux-man@vger.kernel.org
Subject: Re: [PATCH net] tun: handle copy failure in tun_put_user()
Message-ID: <20140120084349.GA7677@redhat.com>
References: <1390187808-5462-1-git-send-email-jasowang@redhat.com>
 <20140119.194856.491294439635992592.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140119.194856.491294439635992592.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 19, 2014 at 07:48:56PM -0800, David Miller wrote:
> From: Jason Wang <jasowang@redhat.com>
> Date: Mon, 20 Jan 2014 11:16:48 +0800
> 
> > This patch return the error code of copy helpers in tun_put_user() instead of
> > ignoring them.
> > 
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Signed-off-by: Jason Wang <jasowang@redhat.com>

I'm not sure we need to worry about this too much.
But if yes, a bunch of places besides tun should be
changed. Consider for example udp_recvmsg: it
never seems to return any error except -EAGAIN.

Is this a bug? Man page for recvmsg says:
     EFAULT The receive buffer pointer(s)  point  outside  the process's  address
              space.

this isn't very clear: does this mean "all pointers are invalid"
or "some pointers are invalid"?
Also, what if pointers themselves are valid but length
makes us go outside the address space?

I'm guessing the simplest way is to clarify in the man page that
passing invalid pointers / lengths is not guaranteed
to result in EFAULT and that Linux makes no guarantees
about the returned length in this case.

Cc linux-man in case they can suggest some insights on this.

> If you perform some of the copy successfully, you have to report that
> length rather than just an error.
> 
> Otherwise userland has no way to determine how much of the data was
> successfully sourced.
>
> I'm not applying this, sorry.
