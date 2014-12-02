Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177AbaLBPdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 10:33:05 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:62758 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaLBPdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 10:33:03 -0500
Message-ID: <1417534380.5303.64.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH 1/2] fs: introduce sendfd() syscall
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alex Dubov <alex.dubov@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Dubov <oakad@yahoo.com>
Date: Tue, 02 Dec 2014 07:33:00 -0800
In-Reply-To: <CAPs88r_Dz+UqwhqAcKwXuLZGz4n=NocD-0FuOZug5UGH64p_8w@mail.gmail.com>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
	 <1417494919-4577-2-git-send-email-oakad@yahoo.com>
	 <1417524607.5303.45.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CAPs88r_Dz+UqwhqAcKwXuLZGz4n=NocD-0FuOZug5UGH64p_8w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 01:47 +1100, Alex Dubov wrote:
> > User A can send fd(s) to processes belonging to user B, even if user B
> > does (probably) not want this to happen ?
> 
> 1. Process A must have sufficient permissions to signal process B.
> This will only happen if process A belongs to the same user as process
> B or has elevated capabilities, which can not appear by themselves
> (and if root on some machine can not be trusted, then all is lost
> anyway).
> 

I do not see this enforced in your patch.

Allowing a process to hold many times the lock protecting my file
descriptor table is very scary.

Reserving a slot, then undo this if the signal failed is a nice way to
slow down critical programs and eventually block them from doing
progress when using file descriptors (most system calls afaik)


> 2. If process B has not specified explicitly how it wants the
> particular signal to be handled, it will be killed by the default
> handler. End of story, nothing else is going to happen.

So it seems possible for an arbitrary program to send fds to innocent
programs, that will likely fill their fd table and wont be able to open
a new file.

This opens interesting security issues and attack vectors.


