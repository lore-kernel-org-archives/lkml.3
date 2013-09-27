Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab3I0VFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 17:05:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40252 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab3I0VFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 17:05:20 -0400
Date: Fri, 27 Sep 2013 22:05:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Crash of 3.12-rc2 BUG: unable to handle kernel NULL pointer
	dereference
Message-ID: <20130927210505.GM12758@n2100.arm.linux.org.uk>
References: <524572BF.5060407@redhat.com> <5245845F.5090100@redhat.com> <CAErSpo74E-EKJN16A44UEGraZ9NE09a5q2_zQrkMuOANtQx0rQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo74E-EKJN16A44UEGraZ9NE09a5q2_zQrkMuOANtQx0rQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 10:04:44AM -0600, Bjorn Helgaas wrote:
> [+cc Thomas, Russell]

Someone is doing something quite bad in the kernel, and as yet I've not
figured out a way to track it down.

The issue is this: someone is kfree'ing a kobject before its release
function has been called, and the memory is being re-used.  The problem
is that when the last reference has been dropped with the debug enabled,
the kobject is linked into the timer lists for the delayed work.  When
the timer lists get run, they're found to be corrupted.

The obvious solution to this is to move the delayed work out of the
kobject into a separately allocated structure.  That would work if
x86 didn't register kobjects very early in boot, before the memory
allocators were up and running.

Frankly, I've no idea how to solve this.  So I regard x86 as just being
difficult and broken.  :)

If anyone has any ideas, then I'm all ears.
http://www.annhuey.com/ed-pix/fa_i-pix/I%27m-All-Ears.jpg
