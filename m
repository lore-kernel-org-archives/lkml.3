Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaCGXJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 18:09:00 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51608 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaCGXI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 18:08:58 -0500
Date: Fri, 7 Mar 2014 15:08:56 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Kumar Gala <galak@codeaurora.org>, Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 2/4] devicetree: bindings: Document Krait CPU/L1 EDAC
Message-ID: <20140307230856.GE9985@codeaurora.org>
References: <20140116013840.GA674@codeaurora.org>
 <20140116113332.GC25540@e102568-lin.cambridge.arm.com>
 <20140116180505.GA30925@codeaurora.org>
 <20140116183326.GG25540@e102568-lin.cambridge.arm.com>
 <20140116192617.GA13785@codeaurora.org>
 <20140117102109.GA22544@e102568-lin.cambridge.arm.com>
 <20140219002043.GE14769@codeaurora.org>
 <20140225111655.GA6855@e102568-lin.cambridge.arm.com>
 <E34E6789-03BC-452C-9053-82CA1D027861@codeaurora.org>
 <20140226120103.GA25326@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226120103.GA25326@e102568-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Lorenzo Pieralisi wrote:
> On Tue, Feb 25, 2014 at 08:48:38PM +0000, Kumar Gala wrote:
> > 
> > On Feb 25, 2014, at 5:16 AM, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com> wrote:
> > > 
> > > As I mentioned, I do not like the idea of adding compatible properties
> > > just to force the kernel to create platform devices out of device tree
> > > nodes. On top of that I would avoid adding a compatible property
> > > to the cpus node (after all properties like enable-method are common for all
> > > cpus but still duplicated), my only concern being backward compatibility
> > > here (ie if we do that for interrupts, we should do that also for other
> > > common cpu nodes properties, otherwise we have different rules for
> > > different properties).
> > > 
> > > I think you can then add interrupts to cpu nodes ("qcom,krait" specific),
> > > and as you mentioned create a platform device for that.
> > > 
> > > Thanks,
> > > Lorenzo
> > 
> > So I agree with the statement about adding compatibles just to create platform devices is wrong.  However its seems perfectly reasonable for a cpu node to have a compatible property.  I don't see why a CPU is any different from any other device described in a DT.
> 
> I was referring to the /cpus node, not to individual cpu nodes, where
> the compatible property is already present now.
> 

Ok I think I'll go ahead with moving the interrupts into each cpu node, i.e.:

        cpus {  
                #address-cells = <1>;
                #size-cells = <0>;

                cpu@0 { 
                        compatible = "qcom,krait";
                        device_type = "cpu";
                        reg = <0>;
                        interrupts = <1 14 0x304>;
                        next-level-cache = <&L2>;
                };

                cpu@1 { 
                        compatible = "qcom,krait";
                        device_type = "cpu";
                        reg = <1>;
                        interrupts = <1 14 0x304>;
                        next-level-cache = <&L2>;
                };

                L2: l2-cache {
                        compatible = "cache";
                        interrupts = <0 2 0x4>;
		};
	};

Or should we be expressing the L1 cache as well? Something like:

        cpus {  
                #address-cells = <1>;
                #size-cells = <0>;

                cpu@0 { 
                        compatible = "qcom,krait";
                        device_type = "cpu";
                        reg = <0>;
                        next-level-cache = <&L1_0>;

			L1_0: l1-cache {
				compatible = "arm,arch-cache";
				interrupts = <1 14 0x304>;
				next-level-cache = <&L2>;
			}
                };

                cpu@1 { 
                        compatible = "qcom,krait";
                        device_type = "cpu";
                        reg = <1>;
                        next-level-cache = <&L1_1>;

			L1_1: l1-cache {
				compatible = "arm,arch-cache";
				interrupts = <1 14 0x304>;
				next-level-cache = <&L2>;
			}
                };

                L2: l2-cache {
                        compatible = "arm,arch-cache";
                        interrupts = <0 2 0x4>;
		};
	};

(I'm also wondering if the 3rd cell of the interrupt binding
should only indicate the CPU that the interrupt property is
inside?)

Finally we can have the edac driver look for a "qcom,krait"
compatible node in cpus that it can create a platform device for,
i.e..

static int __init krait_edac_driver_init(void)
{
        struct device_node *np;

        np = of_get_cpu_node(0, NULL);
        if (!np)
                return 0;

        if (!krait_edacp && of_device_is_compatible(np, "qcom,krait"))
                krait_edacp = of_platform_device_create(np, "krait_edac", NULL);
        of_node_put(np);

        return platform_driver_register(&krait_edac_driver);
}
module_init(krait_edac_driver_init);

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
