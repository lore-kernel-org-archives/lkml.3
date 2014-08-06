Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610AbaHFQy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 12:54:59 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53773 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932594AbaHFQy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 12:54:56 -0400
Date: Wed, 6 Aug 2014 09:54:52 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] of/irq: lookup 'interrupts-extended' property first
Message-ID: <20140806165452.GN3711@ld-irv-0074>
References: <1403220823-19444-1-git-send-email-f.fainelli@gmail.com>
 <CAGVrzcYfA8rCXGRW7g0JhT4GQKT8SQj+pMvCh25yoXLFGNM_Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGVrzcYfA8rCXGRW7g0JhT4GQKT8SQj+pMvCh25yoXLFGNM_Pw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant, et al,

Can we get a comment here?

On Thu, Jul 31, 2014 at 11:00:01AM -0700, Florian Fainelli wrote:
> 2014-06-19 16:33 GMT-07:00 Florian Fainelli <f.fainelli@gmail.com>:
> > In case the Device Tree blob passed by the boot agent supplies both an
> > 'interrupts-extended' and an 'interrupts' property in order to allow for
> > older kernels to be usable, prefer the new-style 'interrupts-extended'
> > property which convey a lot more information.
> >
> > This allows us to have bootloaders willingly maintaining backwards
> > compatibility with older kernels without entirely deprecating the
> > 'interrupts' property (although that is a clear violation of the binding
> > specified at
> > Documentation/devicetree/bindings/interrupt-controller/interrupts.txt)

For the patch:

Acked-by: Brian Norris <computersforpeace@gmail.com>

I think it is important that a device tree provide some flexibility on
kernel versions. We only invented 'interrupts-extended' in Linux 3.13,
so it's easy to have device trees that could work only on 3.13+.

Typically, we might say that new features require new kernels, but this
is a very basic piece of the DT infrastructure. In our case, we have
hardware whose basic features can be supported by a single interrupt
parent, and so we used the 'interrupts' property pre-3.13. But when we
want to add some power management features, there's an additional
interrupt parent. Under the current DT binding, we have to switch over
to using 'interrupts-extended' exclusively, and thus we must have a
completely new DTB for >=3.13, and this DTB no longer works with the old
kernels.

How's that for DT stability?

On the other hand, if we support this precedence concept, then a new DTB
can provide both the 'interrupts-extended' and 'interrupts' properties,
and thus be compatible with both pre-3.13 and
post-<whenever-this-is-accepted> kernels.

> Any comments on this? Brian suggested that I update
> interrupt-controller/interrupts.txt to specify the look up ordering
> change as well.

What do you think about the following DT binding doc update to accompany
this change?

Signed-off-by: Brian Norris <computersforpeace@gmail.com>

diff --git a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
index 1486497a24c1..ce6a1a072028 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
+++ b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
@@ -4,11 +4,13 @@ Specifying interrupt information for devices
 1) Interrupt client nodes
 -------------------------
 
-Nodes that describe devices which generate interrupts must contain an either an
-"interrupts" property or an "interrupts-extended" property. These properties
-contain a list of interrupt specifiers, one per output interrupt. The format of
-the interrupt specifier is determined by the interrupt controller to which the
-interrupts are routed; see section 2 below for details.
+Nodes that describe devices which generate interrupts must contain an
+"interrupts" property, an "interrupts-extended" property, or both. If both are
+present, the latter should take precedence; the former may be provided simply
+for compatibility with software that does not recognize the latter. These
+properties contain a list of interrupt specifiers, one per output interrupt. The
+format of the interrupt specifier is determined by the interrupt controller to
+which the interrupts are routed; see section 2 below for details.
 
   Example:
 	interrupt-parent = <&intc1>;
