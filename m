Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbaAVVtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 16:49:31 -0500
Received: from mail-gg0-f171.google.com ([209.85.161.171]:56346 "EHLO
	mail-gg0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaAVVta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 16:49:30 -0500
Date: Wed, 22 Jan 2014 13:49:26 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jiri Kosina <jkosina@suse.cz>
cc: Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@parisplace.org>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: Slab corruption in fanotify_free_event()
In-Reply-To: <alpine.LNX.2.00.1401221347240.27143@pobox.suse.cz>
Message-ID: <alpine.DEB.2.02.1401221347390.22014@chino.kir.corp.google.com>
References: <alpine.LNX.2.00.1401221347240.27143@pobox.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jan 2014, Jiri Kosina wrote:

> Hi,
> 
> booting current Linus' tree (df32e43a), I am getting
> 
>  Slab corruption (Not tainted): fanotify_event_info start=ffff8800372e3320, len=64
>  Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
>  Last user: [<ffffffff811e0bdd>](fanotify_free_event+0x2d/0x40)
>  030: 6b 6b 6b 6b 6b 6b 6b 6b 00 00 00 00 6b 6b 6b a5  kkkkkkkk....kkk.
>  Prev obj: start=ffff8800372e32c8, len=64
>  Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
>  Last user: [<ffffffff811e0bdd>](fanotify_free_event+0x2d/0x40)
>  000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
>  010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
>  Next obj: start=ffff8800372e3378, len=64
>  Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
>  Last user: [<ffffffff811e0bdd>](fanotify_free_event+0x2d/0x40)
>  000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
>  010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> 
> I guess this is due to
> 
> 	commit 7053aee26a3548ebaba046ae2e52396ccf56ac6c
> 	Author: Jan Kara <jack@suse.cz>
> 	Date:   Tue Jan 21 15:48:14 2014 -0800
> 
> 	    fsnotify: do not share events between notification groups
> 
> as I am not able to see any other recent changes in that area. Haven't 
> been looking at the patch closely enough to debug this yet ... sending 
> this as an early heads-up.
> 

Dave Jones reports slab poison values getting overwritten and bisected it 
to the same commit.  The discussion is at 
http://marc.info/?t=139037220800006.
