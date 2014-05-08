Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbaEHT1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:27:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbaEHT1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:27:02 -0400
Date: Thu, 8 May 2014 15:26:22 -0400
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, peterz@infradead.org,
        davidlohr@hp.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [3.15-rc3] rtmutex-debug assertion.
Message-ID: <20140508192622.GB22827@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>, peterz@infradead.org,
	davidlohr@hp.com, Linus Torvalds <torvalds@linux-foundation.org>
References: <20140429151655.GA14277@redhat.com>
 <20140430001432.GA32142@redhat.com>
 <alpine.DEB.2.02.1404301113110.6261@ionos.tec.linutronix.de>
 <20140502045640.GA27264@redhat.com>
 <alpine.DEB.2.02.1405052002360.6261@ionos.tec.linutronix.de>
 <20140505182942.GA19129@redhat.com>
 <alpine.DEB.2.02.1405081726250.6261@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1405081726250.6261@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 05:28:54PM +0200, Thomas Gleixner wrote:

 > >  > All I see in dmesg are occasional ooms which kill random trinity
 > >  > childs. 
 > > 
 > > hm, that sounds odd. if it's only fuzzing futex, it shouldn't be
 > > doing much memory allocation.
 > 
 > It has a fast memory leak of some sort.
 > 
 > 9271 tglx      20   0  198908  75320   2992 S   0.7  7.4   0:01.94 trinity-c0
 > 9271 tglx      20   0  256888 104368   2992 S   3.3 10.2   0:02.78 trinity-c0
 
ah, it's probably where it generates a random address.
See random-address.c:get_writable_address.  This is hitting the 'zmalloc' case.
For the most time, leaking this isn't a big deal, as the child usually
crashes in some way before it becomes a problem. But when we narrow the
possible syscalls it can run as we have in this case, it runs and runs..
until oom.

You could either chop out that case of the switch, or do something like
this..

while [ 1 ];
do
  ./trinity -c futex -l off -q -n 1000000
done

Which forces it to quit and restart every million syscalls.

Kinda hacky, but I've not had motivation to get around to fixing this
(and similar) leaks so far because I keep finding more interesting
things to work on..

	Dave

