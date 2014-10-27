Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbaJ0KFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 06:05:09 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:57228 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaJ0KFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 06:05:07 -0400
Message-ID: <1414404302.5564.70.camel@marge.simpson.net>
Subject: Re: bisected: futex regression >= 3.14 - was - Slowdown due to
 threads bouncing between HT cores
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Mon, 27 Oct 2014 11:05:02 +0100
In-Reply-To: <20141026141144.GA22911@sesse.net>
References: <20141003194428.GA27084@sesse.net>
	 <1412782664.5179.75.camel@marge.simpson.net>
	 <CA+55aFyuH07zzD6dD4k0pdyvJ7fUhFdFrmPYJi9W=FtHihgndA@mail.gmail.com>
	 <1412791184.5173.11.camel@marge.simpson.net>
	 <alpine.DEB.2.11.1410241724370.5308@nanos>
	 <1414168721.5308.3.camel@marge.simpson.net>
	 <20141026103918.GA5259@sesse.net>
	 <1414329375.5304.20.camel@marge.simpson.net>
	 <1414331916.5304.23.camel@marge.simpson.net>
	 <20141026141144.GA22911@sesse.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-10-26 at 15:11 +0100, Steinar H. Gunderson wrote: 
> I'm maybe a bit surprised nobody else can
> reproduce my issue;

I tried again this morning, and failed again this morning.

>From notes...

box = 2 socket, 14 cores/socket +ht, kernel = v3.18-rc2

stockfish 28 threads
nps 30511800 time 150120
nps 31337817 time 197553
nps 30675979 time 183005
nps 30706678 time 205037
nps 33389720 time 319808 (note massive runtime (ms) variance)
avg 30046381      211104

Adds perturbation source - ring-test -t 56 -w 1 -s 1 -p
(pipe ring, work 1ms, sleep 1ms, thread 0-55 pinned to cpu 0-55)

One ring did nada, bump to 5 concurrent rings.

nps 29443509 time 177969
nps 28713560 time 159663
nps 30628452 time 192714
nps 28834888 time 151611
nps 32611498 time 387760

Hm, still nada, try _10_.

nps 29998092 time 164625
nps 31142316 time 178655

Heh, 10 rings of pokers, still nada, try heavier tbench.

...

4 tbench pairs - 4 full cpus worth of competition
nps 27157639 time 144184
nps 26511984 time 143998
nps 28408851 time 182903
nps 28501510 time 157897
nps 28357045 time 172855
avg 27787405      160367 (avg runtime drops?.. shrug)

Ah, finally a nps delta.. but nothing unexpected.

vs zero competition, average nps is 0.924

4 cpus shared ~= stockfish runs on 26 cpus, 26/28 = 0.928

Test session summary: the sun moved westward.

