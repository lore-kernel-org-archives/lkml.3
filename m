Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbaAMTYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:24:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbaAMTYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:24:13 -0500
Date: Mon, 13 Jan 2014 19:24:06 +0000
From: Mel Gorman <mgorman@suse.de>
To: Len Brown <len.brown@intel.com>
Cc: athorlton@sgi.com, riel@redhat.com, chegu_vinod@hp.com,
        Greg KH <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: Idle power fix regresses ebizzy performance (was 3.12-stable
 backport of NUMA balancing patches)
Message-ID: <20140113192406.GL27046@suse.de>
References: <1389103248-17617-1-git-send-email-mgorman@suse.de>
 <20140107141715.GA32491@kroah.com>
 <20140107185440.GA7844@kroah.com>
 <20140107203012.GA27046@suse.de>
 <20140108104340.GC27046@suse.de>
 <20140108134858.GF27046@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140108134858.GF27046@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 01:48:58PM +0000, Mel Gorman wrote:
> Adding LKML to the list as this -stable snifftest has identified an
> upstream regression.
> 

This is a false alarm.

The test machine in question was originally installed based on a beta
version of openSUSE 13.1. It included a package by default that set default
malloc parameters that I was not aware. Normally the package is there to
catch bugs during beta testing and removed before a GA release but it's
left in place if a user does a distribution update.

With the debugging RPM installed, the free paths contended on a global
mutex in glibc.  Ebizzy had been classified as a CPU intensive and memory
free intensive benchmark (not that common) but turbostat showed that the
CPUs were over 95% of the time in C6 and mpstat verified that the CPUs
were mostly idle. It did not take long to see that everything was blocked
waiting on a futex and to identify where it was in glibc. It's only a
factor when malloc debugging is enabled so normally people would not see it.

The "regression" is because CPUs are reaching C6 as they should and there
is a delay when exiting it. This is behaving as designed and fixing this
would involve doing something stupid. Once the problem RPM was removed
ebizzy performed as expected. 3.13-rc7, the revert and forcing max_cstate=1
all have similar performance.

Sorry about the noise.

-- 
Mel Gorman
SUSE Labs
