Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab3L0Uof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 15:44:35 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:64324 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754725Ab3L0Uoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 15:44:34 -0500
Message-ID: <1388177072.9086.33.camel@x220>
Subject: mei: me: unneeded tests in mei_me_hw_ready_wait()
From: Paul Bolle <pebolle@tiscali.nl>
To: Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org
Date: Fri, 27 Dec 2013 21:44:32 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Dec 2013 20:44:32.0645 (UTC) FILETIME=[723F6350:01CF0344]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) mei_me_hw_ready_wait() currently reads:
        int err;
        [...]

        err = wait_event_interruptible_timeout(dev->wait_hw_ready,
                        dev->recvd_hw_ready,
                        mei_secs_to_jiffies(MEI_INTEROP_TIMEOUT));
        [...]
        if (!err && !dev->recvd_hw_ready) {
                if (!err)
                        err = -ETIMEDOUT;
                dev_err(&dev->pdev->dev,
                        "wait hw ready failed. status = %d\n", err);
                return err;
        }
	[...]

1) The second check for !err was introduced in commit dab9bf41b23f
("mei: me: fix waiting for hw ready"). It's not needed. And the check
for !dev->recvd_hw_ready seems unneeded too.

2) So perhaps something like this was intended:
        [...]
        if (err <= 0) {
                if (!err)
                        err = -ETIMEDOUT;
                dev_err(&dev->pdev->dev,
                        "wait hw ready failed. status = %d\n", err);
                return err;
        }
        [...]

But that's just a guess. For example: it is unclear whether that would
handle wait_event_interruptible_timeout() returning -ERESTARTSYS
correctly. So I'm unable to draft and submit a patch here.


Paul Bolle

