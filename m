Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965661Ab3DPXao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 19:30:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965617Ab3DPXan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 19:30:43 -0400
Date: Tue, 16 Apr 2013 16:30:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Emmanuel Benisty <benisty.e@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>
Subject: Re: ipc,sem: sysv semaphore scalability
Message-Id: <20130416163041.dfa3e82bfa6b10ae8ffe7608@linux-foundation.org>
In-Reply-To: <20130326113533.41ad9ee33b2d010b2a83e7c0@linux-foundation.org>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<CA+i8gKKK_VxZtyyp1tqHnztd4++XyNXwbEEr-A29-J23PyuCfQ@mail.gmail.com>
	<CA+55aFzqBEX=cGGZJJsfNWcDwQcUOP7njEog-kZZLRxuDg8Tzg@mail.gmail.com>
	<CA+i8gK+h+FyPiOL85BPa-Pu8+bDw6LW60-oRoLHgP2AnzMADCA@mail.gmail.com>
	<CA+55aFxjGFi+gt3UwdVCVKP5riHSR=_qLkp0SovgW2zx+gcRow@mail.gmail.com>
	<CA+i8gKJuykoCk=O3qbDmmZXd=8U13wF7o_NzUviccaZoU6WLaA@mail.gmail.com>
	<CA+55aFwb9v9cUG4Ton3faO6xAD18JxxoTPcObXDV_5Zf3QQ=Kw@mail.gmail.com>
	<CA+i8gK+DNOk5tvRsVJFKyk0A2qOD_az7yJ5+3Y2xS=Ear1VkVA@mail.gmail.com>
	<1364320767.5146.11.camel@buesod1.americas.hpqcorp.net>
	<20130326113533.41ad9ee33b2d010b2a83e7c0@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Mar 2013 11:35:33 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> Do we need the locking at all?  What does it actually do?
> 
> 			sem_lock_and_putref(sma);
> 			if (sma->sem_perm.deleted) {
> 				sem_unlock(sma, -1);
> 				err = -EIDRM;
> 				goto out_free;
> 			}
> 			sem_unlock(sma, -1);
> 
> We're taking the lock, testing an int and then dropping the lock. 
> What's the point in that?

Rikpoke.

The new semctl_main() is now taking a lock, testing
sma->sem_perm.deleted then dropping that lock.  It looks wrong.  What
is that lock testing against?  What prevents .deleted from changing
value 1ns after we dropped that lock?

