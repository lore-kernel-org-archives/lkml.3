Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab3AYA0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 19:26:01 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50918 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab3AYAZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 19:25:55 -0500
Date: Fri, 25 Jan 2013 00:25:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Matt Fleming <matt.fleming@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] efivars write(2) races
Message-ID: <20130125002552.GC4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	1) process A does write() on efivars file, reaches ->get_variable(),
gets newdatasize set, drops efivars->lock and loses CPU before an attempt to
grab ->i_mutex.  process B comes and does the same thing, replacing the
variable contents.  Then it grabs ->i_mutex, updates size, drops ->i_mutex
and buggers off.  At which point A gets CPU back and proceeds to set size
to whatever would be valid for its write.  Only the value is bogus now...

	2) what's to prevent EFI_NOT_FOUND being hit twice?  Bad things
will obviously happen in that case...

