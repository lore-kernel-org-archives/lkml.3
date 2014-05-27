Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaE0KU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 06:20:27 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50777 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaE0KUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 06:20:24 -0400
Date: Tue, 27 May 2014 13:20:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, gregkh@linuxfoundation.org, markh@compro.net,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] staging: dgap: implement proper error handling in
 dgap_firmware_load()
Message-ID: <20140527102002.GI17724@mwanda>
References: <20140527070937.GA21621@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140527070937.GA21621@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "brd->nasync = 0;" was wrong, yes, but my main complaint was that
you are writing complicated error handling.  This v2 patch makes the
error handling even more complicated.  If dgap_tty_init() fails it
should free the things it allocates itself, instead of the caller
handling errors for it.

It's not actually that hard.  The only error handling we need to do in
dgap_tty_init() is if the kzalloc() fails:

  1374          /*
  1375           * Allocate channel memory that might not have been allocated
  1376           * when the driver was first loaded.
  1377           */
  1378          for (i = 0; i < brd->nasync; i++) {
  1379                  if (!brd->channels[i]) {
  1380                          brd->channels[i] =
  1381                                  kzalloc(sizeof(struct channel_t), GFP_KERNEL);
  1382                          if (!brd->channels[i])
  1383                                  return -ENOMEM;

Instead of returning directly here we should free the previous
allocations.

  1384                  }
  1385          }

The code is confusing because which ones did we allocate and which ones
were already non-NULL at the start of the function?  In other words
the "if (!brd->channels[i]) {" test?

The answer is that the comment and the test seem to be wrong they were
all NULL at the start of the function.  Just add a:

free_chan:
	while (--i >= 0) {
		kfree(brd->channels[i]);
		brd->channels[i] = NULL;
	}
	return ret;

Actually, for these I would introduce an "int chan" variable just for
that loop instead of "i" which we re-use.

So then we remove the call to dgap_tty_uninit() from
dgap_firmware_load().

regards,
dan carpenter

