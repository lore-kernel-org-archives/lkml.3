Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab3IZVOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 17:14:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab3IZVOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 17:14:38 -0400
Date: Thu, 26 Sep 2013 14:14:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?UTF-8?Q?=E5=BE=90=E6=B0=B8=E5=81=A5?= <xuyongjiande@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Buffer Overflow in drivers/video/fbmem.c
Message-Id: <20130926141436.6eec4671868526dbf15238da@linux-foundation.org>
In-Reply-To: <CABVvea3mENMUqUtb2OGUN+vXqMVPVEgtna4w56gT1dh7gh7r7Q@mail.gmail.com>
References: <CABVvea3mENMUqUtb2OGUN+vXqMVPVEgtna4w56gT1dh7gh7r7Q@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Sep 2013 19:32:04 +0800 _________ <xuyongjiande@gmail.com> wrote:

> Hi,
> Buffer overflow found in drivers/video/fbmem.c.
> [Version]:Newest
> 
> [Detail]:
> 1592 static int do_register_framebuffer(struct fb_info *fb_info)
> 1593 {
> 1594 |   int i;
> 1595 |   struct fb_event event;
> 1596 |   struct fb_videomode mode;
> ........
> 1607 |   num_registered_fb++;
> 1608 |   for (i = 0 ; i < FB_MAX; i++)    //******* i could be FB_MAX
> after loop *********/
> 1609 |   |   if (!registered_fb[i])
> 1610 |   |   |   break;
> ........
> 
> 1646 |   fb_var_to_videomode(&mode, &fb_info->var);
> 1647 |   fb_add_videomode(&mode, &fb_info->modelist);
> 1648 |   registered_fb[i] = fb_info;          // ****** Here will be a
> off-by-one overflow  *******/

I don't think so.  This test:

	if (num_registered_fb == FB_MAX)
		return -ENXIO;

guarantees that there is at least one empty entry in registered_fb[],
so `i' will never reach FB_MAX.


