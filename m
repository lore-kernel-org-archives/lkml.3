Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935844Ab3DPKdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 06:33:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51222 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab3DPKdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 06:33:35 -0400
Date: Tue, 16 Apr 2013 11:33:21 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Matt Fleming <matt.fleming@intel.com>, Lingzhu Xiang <lxiang@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        Michael Schroeder <mls@suse.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 097/102] efivars: explicitly calculate length of
 VariableName
Message-ID: <20130416103321.GB3054@hercules>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
 <1365414657-29191-98-git-send-email-luis.henriques@canonical.com>
 <1365547506.5814.36.camel@deadeye.wl.decadent.org.uk>
 <51653E81.4090102@redhat.com>
 <20130410121730.GB3049@hercules>
 <A5ED84D3BB3A384992CBB9C77DEDA4D41AF8D09E@USINDEM103.corp.hds.com>
 <20130411091256.GA11370@hercules>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411091256.GA11370@hercules>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Ben back to the CC list; not sure how his email was dropped)

On Thu, Apr 11, 2013 at 10:12:56AM +0100, Luis Henriques wrote:
> On Wed, Apr 10, 2013 at 03:57:12PM +0000, Seiji Aguchi wrote:
> > 
> > 
> > > -----Original Message-----
> > > From: Luis Henriques [mailto:luis.henriques@canonical.com]
> > > Sent: Wednesday, April 10, 2013 8:18 AM
> > > To: Lingzhu Xiang
> > > Cc: Ben Hutchings; Seiji Aguchi; linux-kernel@vger.kernel.org; stable@vger.kernel.org; kernel-team@lists.ubuntu.com; Matthew
> > > Garrett; Josh Boyer; Michael Schroeder; Lee, Chun-Yi; Matt Fleming
> > > Subject: Re: [PATCH 097/102] efivars: explicitly calculate length of VariableName
> > > 
> > > On Wed, Apr 10, 2013 at 06:27:13PM +0800, Lingzhu Xiang wrote:
> > > > On 04/10/2013 06:45 AM, Ben Hutchings wrote:
> > > > >On Mon, 2013-04-08 at 10:50 +0100, Luis Henriques wrote:
> > > > >>3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.
> > > > >>
> > > > >>------------------
> > > > >>
> > > > >>From: Matt Fleming <matt.fleming@intel.com>
> > > > >>
> > > > >>commit ec50bd32f1672d38ddce10fb1841cbfda89cfe9a upstream.
> > > > >>
> > > > >>It's not wise to assume VariableNameSize represents the length of
> > > > >>VariableName, as not all firmware updates VariableNameSize in the
> > > > >>same way (some don't update it at all if EFI_SUCCESS is returned).
> > > > >>There are even implementations out there that update
> > > > >>VariableNameSize with values that are both larger than the string
> > > > >>returned in VariableName and smaller than the buffer passed to
> > > > >>GetNextVariableName(), which resulted in the following bug report
> > > > >>from Michael Schroeder,
> > > > >>
> > > > >>   > On HP z220 system (firmware version 1.54), some EFI variables are
> > > > >>   > incorrectly named :
> > > > >>   >
> > > > >>   > ls -d /sys/firmware/efi/vars/*8be4d* | grep -v -- -8be returns
> > > > >>   > /sys/firmware/efi/vars/dbxDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> > > > >>   > /sys/firmware/efi/vars/KEKDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> > > > >>   > /sys/firmware/efi/vars/SecureBoot-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> > > > >>   >
> > > > >> /sys/firmware/efi/vars/SetupMode-Information8be4df61-93ca-11d2-aa0d
> > > > >> -00e098032b8c
> > > > >>
> > > > >>The issue here is that because we blindly use VariableNameSize
> > > > >>without verifying its value, we can potentially read garbage values
> > > > >>from the buffer containing VariableName if VariableNameSize is
> > > > >>larger than the length of VariableName.
> > > > >>
> > > > >>Since VariableName is a string, we can calculate its size by
> > > > >>searching for the terminating NULL character.
> > > > >>
> > > > >>Reported-by: Frederic Crozat <fcrozat@suse.com>
> > > > >>Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> > > > >>Cc: Josh Boyer <jwboyer@redhat.com>
> > > > >>Cc: Michael Schroeder <mls@suse.com>
> > > > >>Cc: Lee, Chun-Yi <jlee@suse.com>
> > > > >>Cc: Lingzhu Xiang <lxiang@redhat.com>
> > > > >>Cc: Seiji Aguchi <seiji.aguchi@hds.com>
> > > > >>Signed-off-by: Matt Fleming <matt.fleming@intel.com> [ Backported
> > > > >>for 3.4-stable. Removed workqueue code added in a93bc0c 3.9-rc1. ]
> > > > >[...]
> > > > >
> > > > >I thought the workqueue addition was a worthwhile fix in its own
> > > > >right, so for 3.2.y I cherry-picked that as well.
> > > >
> > > > FWIW, the workqueue patch is 1/2 of this patchset[1] fixing closely
> > > > related problems. The other one is 81fa4e58.
> > > >
> > > > [1]: http://article.gmane.org/gmane.linux.kernel/1439570
> > > >
> > > > I tried to avoid pulling too much for stable because the patchset is
> > > > quite large and I suspect the problem it fixes is only theoretical.
> > > > I reported the original bug but was unable to break anything except
> > > > getting call traces with various CONFIG_DEBUG_*.
> > > >
> > > > What's your opinion, Seiji?
> > > 
> > > Ok, so just to clarify: you're suggesting me to pick the following commits:
> > > 
> > > 81fa4e581d9283f7992a0d8c534bb141eb840a14 efivars: Disable external interrupt while holding efivars->lock
> > > a93bc0c6e07ed9bac44700280e65e2945d864fd4 efi_pstore: Introducing workqueue updating sysfs
> > > ec50bd32f1672d38ddce10fb1841cbfda89cfe9a efivars: explicitly calculate length of VariableName
> > > e971318bbed610e28bb3fde9d548e6aaf0a6b02e efivars: Handle duplicate names from get_next_variable()
> > 
> > I agree to add these commits to a stable tree.
> > 
> Thank you Seiji.  I'll queue these for the next 3.5 kernel.

So, after spending some time around this, I ended up picking much
more commits than those listed above.  Since this code in 3.5.y wasn't
that different from Ben's 3.2.y, I took the liberty of picking all the
bits I was missing from there.  Here's what I ended up with:

d80a361d779a9f19498943d1ca84243209cd5647 efi_pstore: Check remaining space with QueryVariableInfo() before writing data
81fa4e581d9283f7992a0d8c534bb141eb840a14 efivars: Disable external interrupt while holding efivars->lock
68d929862e29a8b52a7f2f2f86a0600423b093cd efi: be more paranoid about available space when creating variables
ed9dc8ce7a1c8115dba9483a9b51df8b63a2e0ef efivars: Allow disabling use as a pstore backend
ec0971ba5372a4dfa753f232449d23a8fd98490e efivars: Add module parameter to disable use as a pstore backend
ca0ba26fbbd2d81c43085df49ce0abfe34535a90 efivars: Fix check for CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE
a93bc0c6e07ed9bac44700280e65e2945d864fd4 efi_pstore: Introducing workqueue updating sysfs
ec50bd32f1672d38ddce10fb1841cbfda89cfe9a efivars: explicitly calculate length of VariableName
e971318bbed610e28bb3fde9d548e6aaf0a6b02e efivars: Handle duplicate names from get_next_variable()
                                         efivars: pstore: Do not check size when erasing variable

(this last commit was picked from 3.2.y directly, its not an upstream
commit)

I'll be sending out 3.5.7.11 for review later this week, and I would
really appreciate any feedback on these commits.

(Ben: Thanks a lot, since most of the backport work was took from your
tree.)

Cheers,
--
Luis
