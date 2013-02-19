Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab3BSQCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 11:02:09 -0500
Received: from smarthost2.mail.uk.easynet.net ([212.135.6.12]:38134 "EHLO
	smarthost2.mail.uk.easynet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932598Ab3BSQCH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 11:02:07 -0500
X-Greylist: delayed 2473 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2013 11:02:07 EST
From: Jean-Francois Dagenais <DagenaisJ@Sonatest.com>
To: Olivier KSIKES <olivier@okprods.com>
CC: "zbr@ioremap.net" <zbr@ioremap.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: w1_ds2408 linux driver
Thread-Topic: w1_ds2408 linux driver
Thread-Index: AQHODq+hzT4V6+pN0kSL+qstSY9rQJiBS/KA
Date: Tue, 19 Feb 2013 15:20:34 +0000
Message-ID: <E2D2B553-AE93-4299-A2BB-2FB0E02AD82C@sonatest.com>
References: <51238FBA.9050600@okprods.com>
In-Reply-To: <51238FBA.9050600@okprods.com>
Accept-Language: en-CA, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.128.91]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <991940CD9F3C674F9CA06F762D8FDA9A@Sonatest.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Mailshell-score: 2, threshold=98, smtpSenderIP=212.56.87.3
	 utc=<2013-02-19 15:20:51>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olivier,

I'm forwarding this to Evgeniy and the linux-kernel mailing list as this thread
may have historical value.

On 2013-02-19, at 9:44 AM, Olivier KSIKES wrote:

> Dear Mr Dagenais,
> 
> I have just tried your w1-ds2408 linux driver on a TP link mini router running openwrt with w1-gpio. I was able to successfully update a 2408 outputs by writing a byte to the /output file.
> However, I would like to drive an LCD screen, and this method seems limited to 3/4 chars per second.

Yikes!

> 
> I had little more luck driving the 2408 thru the generic w1 driver (using the rw file), where I reached around 25 bytes/s.

This is a big surprise to me... Are you sure about the result, i.e. that no
errors are occurring?

> This is however far from the actual 1wire bus capabilities.

Indeed. Did you try turning on the "dev_dbg" prints using "#define DEBUG" at the
top of the file? This will give you clues as to whether bus errors are occurring
and retries are made.

> 
> Thus, I'm wondering if there is a faster way to output a series of bytes to the 2408 using your driver?
> Is there any doc available apart from w1_ds2408.c comments?

A quick inspection of the w1_ds2408 driver reveals that for each byte write
operation, we need to write 3 bytes, then read 1, then a bus reset, then the
resume command (1byte) and after this we go back to read back to see if the
value we wrote worked, which is again 3 bytes written, and 1 read. This is
certainly much longer that doing it the easy way and may be a bit paranoid. I
could see a patch that would make this double checking optional, say when the
module is build with "#define DEBUG" or perhaps with a module option in the
Kconfig which would have the double checking behaviour on by default.

The reason I designed it this way is because 1-wire busses tend to be close to
flaky. Certainly the environment I developed the driver in was flaky. Finally we
resolved the issues with pull-ups and what not, but there are other examples
where the 1-wire bus spec is stretched a bit by certain component.

Having a Kconfig value could enable the double check code to be present for
stabilization purposes, and then turned off once things work so it can run
faster.

Send a patch!

> 
> With best regards and congratulations for your great work,
> 
> Olivier Ksikes

