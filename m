Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760411Ab3DCBwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 21:52:41 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:14494
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756999Ab3DCBwj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 21:52:39 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI98dI9371I1432I1418Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
Date: Tue, 2 Apr 2013 20:52:30 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 5/5 v11] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
To: Timur Tabi <timur@tabi.org>
CC: Joerg Roedel <joro@8bytes.org>, Varun Sethi <Varun.Sethi@freescale.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@kernel.crashing.org>, <stuart.yoder@freescale.com>,
        <iommu@lists.linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <CAOZdJXWS50mpgMYu8o8K11yQFU6y-vNwxd9zPkqSd7euGt7XQg@mail.gmail.com>
	(from timur@tabi.org on Tue Apr  2 20:35:54 2013)
X-Mailer: Balsa 2.4.11
Message-ID: <1364953950.8690.4@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 08:35:54 PM, Timur Tabi wrote:
> On Tue, Apr 2, 2013 at 11:18 AM, Joerg Roedel <joro@8bytes.org> wrote:
> 
> > > +     panic("\n");
> >
> > A kernel panic seems like an over-reaction to an access violation.
> 
> We have no way to determining what code caused the violation, so we
> can't just kill the process.  I agree it seems like overkill, but what
> else should we do?  Does the IOMMU layer have a way for the IOMMU
> driver to stop the device that caused the problem?

At a minimum, log a message and continue.  Probably turn off the LIODN,  
at least if it continues to be noisy (otherwise we could get stuck in  
an interrupt storm as you note).  Possibly let the user know somehow,  
especially if it's a VFIO domain.

Don't take down the whole kernel.  It's not just overkill; it  
undermines VFIO's efforts to make it safe for users to control devices.

> > Besides the device that caused the violation the system should still
> > work, no?
> 
> Not really.  The PAMU was designed to add IOMMU support to legacy
> devices, which have no concept of an MMU.  If the PAMU detects an
> access violation, there's no way for the device to recover, because it
> has no idea that a violation has occurred.  It's going to keep on
> writing to bad data.

I think that's only the case for posted writes (or devices which fail  
to take a hint and stop even after they see an I/O error).

-Scott
