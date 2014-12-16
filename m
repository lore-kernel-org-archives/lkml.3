Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236AbaLPLOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 06:14:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:46501 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbaLPLOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 06:14:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,586,1413270000"; 
   d="scan'208";a="648390217"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Chris Rorvick <chris@rorvick.com>
CC: "Drokin, Oleg" <oleg.drokin@intel.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "HPDD-discuss@ml01.01.org" <HPDD-discuss@ml01.01.org>,
        Greg Donald <gdonald@gmail.com>, James Simmons <uja.ornl@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fabian Frederick" <fabf@skynet.be>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        "Andriy Skulysh" <Andriy_Skulysh@xyratex.com>,
        "Hammond, John" <john.hammond@intel.com>
Subject: Re: [PATCH] drivers: staging: lustre: Use mult if units not
 specified
Thread-Topic: [PATCH] drivers: staging: lustre: Use mult if units not
 specified
Thread-Index: AQHQGPMf3mzcRIWzokq+6LHNt6QZDJySfQ2A//+k1gA=
Date: Tue, 16 Dec 2014 11:14:35 +0000
Message-ID: <D0B55F56.D05F1%andreas.dilger@intel.com>
References: <1418708509-18196-1-git-send-email-chris@rorvick.com>
 <20141216094109.GH4856@mwanda>
In-Reply-To: <20141216094109.GH4856@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.108.8]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <04DB89A574802E4EB66F985DC272676A@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/16, 2:41 AM, "Dan Carpenter" <dan.carpenter@oracle.com> wrote:

>On Mon, Dec 15, 2014 at 11:41:49PM -0600, Chris Rorvick wrote:
>> Units can be passed to lprocfs_write_frac_u64_helper() via a suffix
>> (e.g., "...K", "...M", etc.) tacked onto the value.  A comment states
>> that "specified units override the multiplier," though the multiplier is
>> overridden regardless.  Update the conditional logic so that it only
>> applies when units are specified.
>> 
>
>That introduces a bug.  We need to take the initial '-' into
>consideration.  Just remove the condition.  Also remove the "mult"
>parameter since that is always 1.
>
>	bool negative = false;
>
>	...
>
>	if (*pbuf == '-') {
>		negative = true;
>		pbuf++;
>	}
>
>	...
>
>	mult = negative ? -units : units;

Sorry, that isn't right.  Chris' patch is actually doing the right thing
to check for units > 1.  The proposed change above discards "mult"
entirely, which breaks the users of this function that are not in this
file (e.g. osc_cached_mb_seq_write() or ll_max_cached_mb_seq_write())
that have tunables in units of MB by default, but can also use parameters
with units like "4.5G" for convenience.

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


