Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab3BPJzh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 04:55:37 -0500
Received: from intranet.asianux.com ([58.214.24.6]:16107 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab3BPJzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 04:55:35 -0500
X-Spam-Score: -100.8
Message-ID: <511F578D.60304@asianux.com>
Date: Sat, 16 Feb 2013 17:55:25 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, sameo@linux.intel.com,
        Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Consult] drivers/mfd/twl*-irq:  about "clean up twl4030_sih_setup"
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter Ujfalusi:

  is it better to provide a function to reverse twl4030_sih_setup() ?
  if welcome, I will try.

  if really I try:
      excuse me, I am not quite familiar with ARM (including OMAP).
      so welcome any checks or suggestions before or after I finish implementing.
      for example:
        A) how to construct virtual environments for OMAP
           (excuse me, I have no relative hardware currently)
        B) how to test it
        C) another suggestions what ever you want to provide.

      (they are welcome, not requirement)


  thanks.

  :-)

gchen.


685 /* FIXME need a call to reverse twl4030_sih_setup() ... */
686 
687 /*----------------------------------------------------------------------*/
688 
689 /* FIXME pass in which interrupt line we'll use ... */
690 #define twl_irq_line    0
691 
692 int twl4030_init_irq(struct device *dev, int irq_num)
693 {
694         static struct irq_chip  twl4030_irq_chip;
695         int                     status, i;
696         int                     irq_base, irq_end, nr_irqs;
697         struct                  device_node *node = dev->of_node;
698 
699         /*
700          * TWL core and pwr interrupts must be contiguous because
701          * the hwirqs numbers are defined contiguously from 1 to 15.
702          * Create only one domain for both.
703          */
704         nr_irqs = TWL4030_PWR_NR_IRQS + TWL4030_CORE_NR_IRQS;
705 
706         irq_base = irq_alloc_descs(-1, 0, nr_irqs, 0);
707         if (IS_ERR_VALUE(irq_base)) {
708                 dev_err(dev, "Fail to allocate IRQ descs\n");
709                 return irq_base;
710         }
711 
712         irq_domain_add_legacy(node, nr_irqs, irq_base, 0,
713                               &irq_domain_simple_ops, NULL);
714 
715         irq_end = irq_base + TWL4030_CORE_NR_IRQS;
716 
717         /*
718          * Mask and clear all TWL4030 interrupts since initially we do
719          * not have any TWL4030 module interrupt handlers present
720          */
721         status = twl4030_init_sih_modules(twl_irq_line);
722         if (status < 0)
723                 return status;
724 
725         twl4030_irq_base = irq_base;
726 
727         /*
728          * Install an irq handler for each of the SIH modules;
729          * clone dummy irq_chip since PIH can't *do* anything
730          */
731         twl4030_irq_chip = dummy_irq_chip;
732         twl4030_irq_chip.name = "twl4030";
733 
734         twl4030_sih_irq_chip.irq_ack = dummy_irq_chip.irq_ack;
735 
736         for (i = irq_base; i < irq_end; i++) {
737                 irq_set_chip_and_handler(i, &twl4030_irq_chip,
738                                          handle_simple_irq);
739                 irq_set_nested_thread(i, 1);
740                 activate_irq(i);
741         }
742 
743         dev_info(dev, "%s (irq %d) chaining IRQs %d..%d\n", "PIH",
744                         irq_num, irq_base, irq_end);
745 
746         /* ... and the PWR_INT module ... */
747         status = twl4030_sih_setup(dev, TWL4030_MODULE_INT, irq_end);
748         if (status < 0) {
749                 dev_err(dev, "sih_setup PWR INT --> %d\n", status);
750                 goto fail;
751         }
752 
753         /* install an irq handler to demultiplex the TWL4030 interrupt */
754         status = request_threaded_irq(irq_num, NULL, handle_twl4030_pih,
755                                       IRQF_ONESHOT,
756                                       "TWL4030-PIH", NULL);
757         if (status < 0) {
758                 dev_err(dev, "could not claim irq%d: %d\n", irq_num, status);
759                 goto fail_rqirq;
760         }
761         enable_irq_wake(irq_num);
762 
763         return irq_base;
764 fail_rqirq:
765         /* clean up twl4030_sih_setup */
766 fail:
767         for (i = irq_base; i < irq_end; i++) {
768                 irq_set_nested_thread(i, 0);
769                 irq_set_chip_and_handler(i, NULL, NULL);
770         }
771 
772         return status;
773 }
774 
775 int twl4030_exit_irq(void)
776 {
777         /* FIXME undo twl_init_irq() */
778         if (twl4030_irq_base) {
779                 pr_err("twl4030: can't yet clean up IRQs?\n");
780                 return -ENOSYS;
781         }
782         return 0;
783 }
784 

