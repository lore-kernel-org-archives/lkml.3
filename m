Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615Ab3JORw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:52:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933185Ab3JORwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:52:54 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: jaxboe@fusionio.com
Cc: linux-kernel@vger.kernel.org
Subject: blk_mq_update_queue_map makes an (invalid?) assumption about cpu ordering
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 15 Oct 2013 13:52:50 -0400
Message-ID: <x49fvs2pgjx.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jens,

blk_mq_update_queue_map does this:

        for_each_possible_cpu(i) {
                if (!cpu_online(i)) {
                        map[i] = 0;
                        continue;
                }

...
                first_sibling = get_first_sibling(i);
                if (first_sibling == i) {
                        map[i] = cpu_to_queue_index(nr_uniq_cpus, nr_queues,
                                                        queue);
                        queue++;
                } else
                        map[i] = map[first_sibling];

This assumes that the first_sibling is listed before any other siblings,
which I don't believe is true.  I don't think you get any guaranteed
ordering in that cpu_possible_mask.

... or did I miss something?

Cheers,
Jeff
