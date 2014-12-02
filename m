Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbaLBOrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:47:16 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:38912 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbaLBOrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:47:14 -0500
MIME-Version: 1.0
In-Reply-To: <1417524607.5303.45.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
	<1417494919-4577-2-git-send-email-oakad@yahoo.com>
	<1417524607.5303.45.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Wed, 3 Dec 2014 01:47:13 +1100
Message-ID: <CAPs88r_Dz+UqwhqAcKwXuLZGz4n=NocD-0FuOZug5UGH64p_8w@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs: introduce sendfd() syscall
From: Alex Dubov <alex.dubov@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Dubov <oakad@yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> User A can send fd(s) to processes belonging to user B, even if user B
> does (probably) not want this to happen ?

1. Process A must have sufficient permissions to signal process B.
This will only happen if process A belongs to the same user as process
B or has elevated capabilities, which can not appear by themselves
(and if root on some machine can not be trusted, then all is lost
anyway).

2. If process B has not specified explicitly how it wants the
particular signal to be handled, it will be killed by the default
handler. End of story, nothing else is going to happen.

I suppose, I can add an extra permissions check prior to creating the
new file descriptor in the first place.

> Also, relying on signals seems quite old fashion these days. How about
> multi-threaded programs wanting separate channels to receive fds ?

Most multi-threaded programs share the same file table between all
threads (unless some fancy clone() magic is involved), so the issue is
rather mundane. At any rate, each thread has its own pid and the usual
signal routing applies.

At a more generic level Posix real-time signals are anything, but
old-fashioned. sigqueue()/signalfd() pair provides a very convenient,
low overhead micro-messaging facility with ordered, reliably delivery.
I fail to see what's wrong with making a worthy use of it.
