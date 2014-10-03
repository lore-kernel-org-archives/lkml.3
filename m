Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaJCD2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 23:28:31 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:45637 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbaJCD2a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 23:28:30 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Mike Snitzer <snitzer@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "tytso@mit.edu" <tytso@mit.edu>,
        "gmazyland@gmail.com" <gmazyland@gmail.com>,
        "agk@redhat.com" <agk@redhat.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>
Subject: RE: [PATCH] block: disable entropy contributions from nonrot devices
Thread-Topic: [PATCH] block: disable entropy contributions from nonrot
 devices
Thread-Index: AQHP3p6lbip0aKW3RUaZVqgPDFbDmZwdsErg
Date: Fri, 3 Oct 2014 03:26:27 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CCBFB5@G4W3202.americas.hpqcorp.net>
References: <1412295074-4984-1-git-send-email-snitzer@redhat.com>
In-Reply-To: <1412295074-4984-1-git-send-email-snitzer@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Mike Snitzer
> Sent: Thursday, 02 October, 2014 7:11 PM
> To: axboe@kernel.dk; linux-kernel@vger.kernel.org
> Cc: tytso@mit.edu; gmazyland@gmail.com; agk@redhat.com; mpatocka@redhat.com
> Subject: [PATCH] block: disable entropy contributions from nonrot devices
> 
> Introduce queue_flags_set_nonrot_clear_add_random() and convert all
> block drivers that set QUEUE_FLAG_NONROT over to using it instead.
> 
> Historically, all block devices have automatically made entropy
> contributions.  But as previously stated in commit e2e1a148 ("block: add
> sysfs knob for turning off disk entropy contributions"):
>     - On SSD disks, the completion times aren't as random as they
>       are for rotational drives. So it's questionable whether they
>       should contribute to the random pool in the first place.
>     - Calling add_disk_randomness() has a lot of overhead.
> 
> There are more reliable sources for randomness than non-rotational block
> devices.  From a security perspective it is better to err on the side of
> caution than to allow entropy contributions from unreliable "random"
> sources.

blk-mq defaults to off (QUEUE_FLAG_MQ_DEFAULT does not 
include QUEUE_FLAG_ADD_RANDOM).

Even when it's off in block layer completion processing, all interrupts, 
storage or not, are forced to contribute during hardirq processing.
I've seen this add 3-12 us latency blips every 64 interrupts (when 
the "fast_mix" code runs out of bits).

Example of fast_mix only taking 0.071 us:
(from ftrace function_graph)
  8)               |                                          handle_irq_event() {
  8)               |                                            handle_irq_event_percpu() {
  8)               |                                              do_hpsa_intr_msi [hpsa]() {
  8)   0.060 us    |                                                SA5_performant_completed [hpsa]();
  8)   0.397 us    |                                              }
  8)   0.071 us    |                                              add_interrupt_randomness();
  8)   0.071 us    |                                              note_interrupt();
  8)   1.495 us    |                                            }
  8)   0.045 us    |                                            _raw_spin_lock();
  8)   2.165 us    |                                          }

Example of the 64th bit taking 3.814 us:
  8)               |                                    handle_irq_event() {
  8)               |                                      handle_irq_event_percpu() {
...
  8)               |                                        add_interrupt_randomness() {
  8)               |                                          __mix_pool_bytes() {
  8)   0.312 us    |                                            _mix_pool_bytes();
  8)   0.688 us    |                                          }
  8)               |                                          credit_entropy_bits() {
  8)               |                                            __wake_up() {
  8)   0.070 us    |                                              _raw_spin_lock_irqsave();
  8)   0.050 us    |                                              __wake_up_common();
  8)   0.056 us    |                                              _raw_spin_unlock_irqrestore();
  8)   1.448 us    |                                            }
  8)   0.048 us    |                                            kill_fasync();
  8)   2.313 us    |                                          }
  8)   3.814 us    |                                        }


---
Rob Elliott    HP Server Storage



