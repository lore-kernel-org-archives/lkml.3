Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab3I1RhY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 13:37:24 -0400
Received: from smtp1.uu.se ([130.238.7.54]:53478 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496Ab3I1RhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 13:37:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21063.5036.298114.685836@pilspetsen.it.uu.se>
Date: Sat, 28 Sep 2013 19:36:44 +0200
From: Mikael Pettersson <mikpelinux@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mikael Pettersson <mikpelinux@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Fix pty master read() after slave closes
In-Reply-To: <5245C12E.6070608@hurleysoftware.com>
References: <524493E6.60300@hurleysoftware.com>
	<1380302825-12539-1-git-send-email-peter@hurleysoftware.com>
	<5245C12E.6070608@hurleysoftware.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hurley writes:
 > On 09/27/2013 01:27 PM, Peter Hurley wrote:
 > > Commit f95499c3030fe1bfad57745f2db1959c5b43dca8,
 > >    n_tty: Don't wait for buffer work in read() loop
 > > creates a race window which can cause a pty master read()
 > > to miss the last pty slave write(s) and return -EIO instead,
 > > thus signalling the pty slave is closed. This can happen when
 > > the pty slave is written and immediately closed but before the
 > > tty buffer i/o loop receives the new input; the pty master
 > > read() is scheduled, sees its read buffer is empty and the
 > > pty slave has been closed, and exits.
 > >
 > > Because tty_flush_to_ldisc() has significant performance impact
 > > for parallel i/o, rather than revert the commit, special case this
 > > condition (ie., when the read buffer is empty and the 'other' pty
 > > has been closed) and, only then, wait for buffer work to complete
 > > before re-testing if the read buffer is still empty.
 > >
 > > As before, subsequent pty master reads return any available data
 > > until no more data is available, and then returns -EIO to
 > > indicate the pty slave has closed.
 > >
 > > Reported-by: Mikael Pettersson <mikpelinux@gmail.com>
 > > Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
 > 
 > I tested this patch with the gcc ada ACATS testsuite and got this
 > summary so all seems ok with this patch.
 > 
 > 		=== acats Summary ===
 > # of expected passes		805
 > # of unexpected failures	0
 > 
 > ...
 > 
 > 		=== acats Summary ===
 > # of expected passes		772
 > # of unexpected failures	0
 > 
 > ...
 > 
 > 		=== acats Summary ===
 > # of expected passes		743
 > # of unexpected failures	0
 > 
 > Mikael,
 > 
 > I'd appreciate if you could re-test with this patch and
 > confirm the issue is fixed.

I did a big pile of gcc bootstrap + regression test runs today with
this patch, and everything looks good.  Thus:

Tested-by: Mikael Pettersson <mikpelinux@gmail.com>

Thanks,

/Mikael
