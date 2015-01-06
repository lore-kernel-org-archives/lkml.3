Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbbAFPOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:14:45 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42324 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754388AbbAFPOe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:14:34 -0500
X-Sasl-enc: n+JG1tk49wsUgzFcFJw+tGMt/s6iIjkMgHkFHriG0RvZ 1420557273
From: Erik Grinaker <erik@bengler.no>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: TCP connection issues against Amazon S3
Date: Tue, 6 Jan 2015 15:14:32 +0000
Message-Id: <5DCDADEF-FF9C-4844-8A2C-62E2D3B3B8CE@bengler.no>
Cc: Yuchung Cheng <ycheng@google.com>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CCing Yuchung, as his name comes up in the relevant commits)

After upgrading from Ubuntu 12.04.5 to 14.04.1 we have begun seeing intermittent TCP connection hangs for HTTP image requests against Amazon S3. 3-5% of requests will suddenly stall in the middle of the transfer before timing out. We see this problem across a range of servers, in several data centres and networks, all located in Norway.

A packet dump [1] shows repeated ACK retransmits for some of the requests. Using Ubuntu mainline kernels, we found the problem to have been introduced between 3.11.10 and 3.12.0, possibly in 0f7cc9a3c2bd89b15720dbf358e9b9e62af27126. The problem is also present in 3.18.1. Disabling tcp_window_scaling seems to solve it, but has obvious drawbacks for transfer speeds. Other sysctls do not seem to affect it.

I am not sure if this is fundamentally a kernel bug or a network issue, but we did not see this problem with older kernels.

[1] http://abstrakt.bengler.no/tcp-issues-s3.pcap.bz2