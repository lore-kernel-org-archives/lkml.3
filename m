Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaIMXh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 19:37:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:39939 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaIMXh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 19:37:58 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@fb.com>
Cc: Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: blk-mq timeout handling fixes
Date: Sat, 13 Sep 2014 16:40:07 -0700
Message-Id: <1410651613-1993-1-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.9.1
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series fixes various issues with timeout handling that Robert
ran into when testing scsi-mq heavily.  He tested an earlier version,
and couldn't reproduce the issues anymore, although the series changed
quite significantly since and should probably be retested.

In summary we not only start the blk-mq timer inside the drivers
->queue_rq method after the request has been fully setup, and we
also tell the drivers if we're timing out a reserved (internal)
request or a real one.  Many drivers including will need to handle
those internal ones differently, e.g. for scsi-mq we don't even
have a scsi command structure allocated for the reserved commands.

