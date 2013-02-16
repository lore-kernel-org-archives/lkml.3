Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab3BPKVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 05:21:55 -0500
Received: from intranet.asianux.com ([58.214.24.6]:36159 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab3BPKVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 05:21:54 -0500
X-Spam-Score: -100.8
Message-ID: <511F5DB7.9030800@asianux.com>
Date: Sat, 16 Feb 2013 18:21:43 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, sameo@linux.intel.com
CC: Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion]drivers/mfd/twl*-irq:  calling irq_free_descs when quit,
 after called irq_alloc_descs
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter Ujfalusi:

  we do not call irq_free_descs when quit, although called irq_alloc_descs.

  is it suitable to call irq_free_descs when quit ?
    it seems need additional analysing, please see drivers/mfd/twl6030-irq.c:441
    (after finish calling twl6030_init_irq, the twl6030_irq_base is non-zero)
    (when twl6030_init_irq fail, also need consider whether call irq_free_descs)

  thanks.

  :-)

gchen.

350 int twl6030_init_irq(struct device *dev, int irq_num)
351 {
352         struct                  device_node *node = dev->of_node;
353         int                     nr_irqs, irq_base, irq_end;
354         struct task_struct      *task;
355         static struct irq_chip  twl6030_irq_chip;
356         int                     status = 0;
357         int                     i;
358         u8                      mask[3];
359 
360         nr_irqs = TWL6030_NR_IRQS;
361 
362         irq_base = irq_alloc_descs(-1, 0, nr_irqs, 0);
363         if (IS_ERR_VALUE(irq_base)) {
364                 dev_err(dev, "Fail to allocate IRQ descs\n");
365                 return irq_base;
366         }
367 
368         irq_domain_add_legacy(node, nr_irqs, irq_base, 0,
369                               &irq_domain_simple_ops, NULL);
370 
371         irq_end = irq_base + nr_irqs;
372 
373         mask[0] = 0xFF;
374         mask[1] = 0xFF;
375         mask[2] = 0xFF;
376 
377         /* mask all int lines */
378         twl_i2c_write(TWL_MODULE_PIH, &mask[0], REG_INT_MSK_LINE_A, 3);
379         /* mask all int sts */
380         twl_i2c_write(TWL_MODULE_PIH, &mask[0], REG_INT_MSK_STS_A, 3);
381         /* clear INT_STS_A,B,C */
382         twl_i2c_write(TWL_MODULE_PIH, &mask[0], REG_INT_STS_A, 3);
383 
384         twl6030_irq_base = irq_base;
385 
386         /*
387          * install an irq handler for each of the modules;
388          * clone dummy irq_chip since PIH can't *do* anything
389          */
390         twl6030_irq_chip = dummy_irq_chip;
391         twl6030_irq_chip.name = "twl6030";
392         twl6030_irq_chip.irq_set_type = NULL;
393         twl6030_irq_chip.irq_set_wake = twl6030_irq_set_wake;
394 
395         for (i = irq_base; i < irq_end; i++) {
396                 irq_set_chip_and_handler(i, &twl6030_irq_chip,
397                                          handle_simple_irq);
398                 irq_set_chip_data(i, (void *)irq_num);
399                 activate_irq(i);
400         }
401 
402         dev_info(dev, "PIH (irq %d) chaining IRQs %d..%d\n",
403                         irq_num, irq_base, irq_end);
404 
405         /* install an irq handler to demultiplex the TWL6030 interrupt */
406         init_completion(&irq_event);
407 
408         status = request_irq(irq_num, handle_twl6030_pih, 0, "TWL6030-PIH",
409                              &irq_event);
410         if (status < 0) {
411                 dev_err(dev, "could not claim irq %d: %d\n", irq_num, status);
412                 goto fail_irq;
413         }
414 
415         task = kthread_run(twl6030_irq_thread, (void *)irq_num, "twl6030-irq");
416         if (IS_ERR(task)) {
417                 dev_err(dev, "could not create irq %d thread!\n", irq_num);
418                 status = PTR_ERR(task);
419                 goto fail_kthread;
420         }
421 
422         twl_irq = irq_num;
423         register_pm_notifier(&twl6030_irq_pm_notifier_block);
424         return irq_base;
425 
426 fail_kthread:
427         free_irq(irq_num, &irq_event);
428 
429 fail_irq:
430         for (i = irq_base; i < irq_end; i++)
431                 irq_set_chip_and_handler(i, NULL, NULL);
432 
433         return status;
434 }
435 
436 int twl6030_exit_irq(void)
437 {
438         unregister_pm_notifier(&twl6030_irq_pm_notifier_block);
439 
440         if (twl6030_irq_base) {
441                 pr_err("twl6030: can't yet clean up IRQs?\n");
442                 return -ENOSYS;
443         }
444         return 0;
445 }



