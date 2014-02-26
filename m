Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaBZMBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 07:01:15 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51912 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaBZMBL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 07:01:11 -0500
Date: Wed, 26 Feb 2014 12:01:04 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Kumar Gala <galak@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 2/4] devicetree: bindings: Document Krait CPU/L1 EDAC
Message-ID: <20140226120103.GA25326@e102568-lin.cambridge.arm.com>
References: <20140115165623.GJ14405@codeaurora.org>
 <20140116013840.GA674@codeaurora.org>
 <20140116113332.GC25540@e102568-lin.cambridge.arm.com>
 <20140116180505.GA30925@codeaurora.org>
 <20140116183326.GG25540@e102568-lin.cambridge.arm.com>
 <20140116192617.GA13785@codeaurora.org>
 <20140117102109.GA22544@e102568-lin.cambridge.arm.com>
 <20140219002043.GE14769@codeaurora.org>
 <20140225111655.GA6855@e102568-lin.cambridge.arm.com>
 <E34E6789-03BC-452C-9053-82CA1D027861@codeaurora.org>
MIME-Version: 1.0
In-Reply-To: <E34E6789-03BC-452C-9053-82CA1D027861@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 26 Feb 2014 12:01:12.0477 (UTC) FILETIME=[717CBCD0:01CF32EA]
X-MC-Unique: 114022612010806701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 08:48:38PM +0000, Kumar Gala wrote:
> 
> On Feb 25, 2014, at 5:16 AM, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com> wrote:
> 
> > Hi Stephen,
> > 
> > On Wed, Feb 19, 2014 at 12:20:43AM +0000, Stephen Boyd wrote:
> >> (Sorry, this discussion stalled due to merge window + life events)
> > 
> > Sorry for the delay in replying on my side too.
> > 
> >> On 01/17, Lorenzo Pieralisi wrote:
> >>> On Thu, Jan 16, 2014 at 07:26:17PM +0000, Stephen Boyd wrote:
> >>>> On 01/16, Lorenzo Pieralisi wrote:
> >>>>> On Thu, Jan 16, 2014 at 06:05:05PM +0000, Stephen Boyd wrote:
> >>>>>> On 01/16, Lorenzo Pieralisi wrote:
> >>>>>>> Do we really want to do that ? I am not sure. A cpus node is supposed to
> >>>>>>> be a container node, we should not define this binding just because we
> >>>>>>> know the kernel creates a platform device for it then.
> >>>>>> 
> >>>>>> This is just copying more of the ePAPR spec into this document.
> >>>>>> It just so happens that having a compatible field here allows a
> >>>>>> platform device to be created. I don't see why that's a problem.
> >>>>> 
> >>>>> I do not see why you cannot define a node like pmu or arch-timer and stick
> >>>>> a compatible property in there. cpus node does not represent a device, and
> >>>>> must not be created as a platform device, that's my opinion.
> >>>>> 
> >>>> 
> >>>> I had what you're suggesting before in the original revision of
> >>>> this patch. Please take a look at the original patch series[1]. I
> >>>> suppose it could be tweaked slightly to still have a cache node
> >>>> for the L2 interrupt and the next-level-cache pointer from the
> >>>> CPUs.
> >>> 
> >>> Ok, sorry, we are running around in circles here, basically you moved
> >>> the node to cpus according to reviews. I still think that treating cpus
> >>> as a device is not a great idea, even though I am in the same
> >>> position with C-states and probably will add C-state tables in the cpus
> >>> node.
> >>> 
> >>> http://comments.gmane.org/gmane.linux.power-management.general/41012
> >>> 
> >>> I just would like to see under cpus nodes and properties that apply to
> >>> all ARM systems, and avoid defining properties (eg interrupts) that
> >>> have different meanings for different ARM cores.
> >>> 
> >>> The question related to why the kernel should create a platform device
> >>> out of cpus is still open. I really do not want to block your series
> >>> for these simple issues but we have to make a decision and stick to that,
> >>> I am fine either way if we have a plan.
> >>> 
> >> 
> >> Do you just want a backup plan in case we don't make a platform
> >> device out of the cpus node? I believe we can always add code
> >> somewhere to create a platform device at runtime if we detect the
> >> cpus node has a compatible string equal to "qcom,krait". We could
> >> probably change this driver's module_init() to scan the DT for
> >> such a compatible string and create the platform device right
> >> there. If we get more than one interrupt in the cpus node we can
> >> add interrupt-names and then have software look for interrupts by
> >> name instead of number.
> > 
> > As I mentioned, I do not like the idea of adding compatible properties
> > just to force the kernel to create platform devices out of device tree
> > nodes. On top of that I would avoid adding a compatible property
> > to the cpus node (after all properties like enable-method are common for all
> > cpus but still duplicated), my only concern being backward compatibility
> > here (ie if we do that for interrupts, we should do that also for other
> > common cpu nodes properties, otherwise we have different rules for
> > different properties).
> > 
> > I think you can then add interrupts to cpu nodes ("qcom,krait" specific),
> > and as you mentioned create a platform device for that.
> > 
> > Thanks,
> > Lorenzo
> 
> So I agree with the statement about adding compatibles just to create platform devices is wrong.  However its seems perfectly reasonable for a cpu node to have a compatible property.  I don't see why a CPU is any different from any other device described in a DT.

I was referring to the /cpus node, not to individual cpu nodes, where
the compatible property is already present now.

Lorenzo

