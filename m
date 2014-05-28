Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbaE1HC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:02:56 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35818 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbaE1HCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:02:55 -0400
Date: Wed, 28 May 2014 10:02:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: devel <devel@driverdev.osuosl.org>, Lidza Louina <lidza.louina@gmail.com>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Mark Hounschell <markh@compro.net>
Subject: Re: [PATCH V2] staging: dgap: implement proper error handling in
 dgap_firmware_load()
Message-ID: <20140528070233.GP17724@mwanda>
References: <20140527070937.GA21621@devel.8.8.4.4>
 <20140527102002.GI17724@mwanda>
 <CAHb8M2AceJeFv-KonF+bAFJ-+xssFxx5ytEKhMNZ1c3xm2jvZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHb8M2AceJeFv-KonF+bAFJ-+xssFxx5ytEKhMNZ1c3xm2jvZA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are talking about different things I think.  What I'm saying is that
there is the normal way to do error handling in the kernel.  That's with
a series of labels like this:

	...
	return 0;

err_free_ttys:
	free_ttys();
err_free_channels:
	free_channels();
err_free_brd:
	free_brd();

	return ret;

In this code there are no if statements unless absolutely needed because
of an matching if statement in the allocation code.  The label names
describe what happens at the label.  It is in reverse order from the way
the variables were allocated.

The other thing is that at the end of dgap_tty_register() we have
unwinding like this.

  1304  unregister_serial_drv:
  1305          tty_unregister_driver(brd->serial_driver);
  1306  free_print_drv:
  1307          put_tty_driver(brd->print_driver);
  1308  free_serial_drv:
  1309          put_tty_driver(brd->serial_driver);

We can add a tty_unregister_driver(brd->print_driver) and create a
dgap_tty_unregister().

static void dgap_tty_unregister(struct board_t *brd)
{
	tty_unregister_driver(brd->print_driver);
	tty_unregister_driver(brd->serial_driver);
	put_tty_driver(brd->print_driver);
	put_tty_driver(brd->serial_driver);
}

Very simple and nice.

If you have one label it makes the code too complicated and it causes
bugs.  We call them "one err bugs" because there is one error label.

In your patch it has:
+       dgap_tty_uninit(brd, false);

But it should only be "false" if dgap_tty_init() failed.  If
dgap_tty_register_ports() fails then it should be "true".  Another
problem is that as you say, the earlier function are allocating
resources like dgap_tty_register() but only the last two function calls
have a "goto err_cleanup;" so the error handling is incomplete.

To be honest, I think once dgap the code is cleaned up this error
handling will be easy to write.  We shouldn't have things like:
brd->dgap_major_serial_registered = TRUE; because we will know which
order things were registered and unregister them in the reverse order.

regards,
dan carpenter

