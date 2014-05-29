Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbaE2TE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:04:28 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:51585 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbaE2TE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:04:26 -0400
Message-ID: <1401390263.3645.51.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH v1 3/3] usb: gadget: NCM: Stop RX TCP Bursts getting
 dropped.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jim Baxter <jim_baxter@mentor.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        David Laight <David.Laight@ACULAB.COM>, netdev@vger.kernel.org
Date: Thu, 29 May 2014 12:04:23 -0700
In-Reply-To: <1401383543-10181-4-git-send-email-jim_baxter@mentor.com>
References: <Jim Baxter <jim_baxter@mentor.com>
	 <1401383543-10181-1-git-send-email-jim_baxter@mentor.com>
	 <1401383543-10181-4-git-send-email-jim_baxter@mentor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-29 at 18:12 +0100, Jim Baxter wrote:
> This fixes a problem with dropped packets over 16k CDC-NCM
> when the connection is being heavily used.
> 
> The issue was that the skb truesize for the unpacked NCM
> packets was too high after they were cloned from the 16k
> skb, this lead to the potential memory calculated by the
> Kernel running out of memory earlier then it should.
> 
> Signed-off-by: Jim Baxter <jim_baxter@mentor.com>
> ---

Note the patch is OK, but changelog a bit misleading ;)

Kernel was not running out of memory, because truesize was correct.

The problem here is that a frame was consuming more kernel memory than
really needed, so chances of hitting socket sk_rcvbuf limit was high.

BTW :
#define NTB_OUT_SIZE              16384

alloc_skb(size) ->
	kmalloc(16384 + sizeof(struct skb_shared_info)) ->
		roundup() => 32768

So truesize of the skb was infact ~32KB, which is really insane indeed.
After your patch, its back to ~2KB

Acked-by: Eric Dumazet <edumazet@google.com>



