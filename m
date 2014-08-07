Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbaHGXLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 19:11:53 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:51652 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbaHGXLw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 19:11:52 -0400
X-Cam-AntiVirus: found ScamNailer.Phish.viro_AT_zeniv.linux.org.uk
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Bug introduced in 3b93f911d5
From: Anton Altaparmakov <aia21@cam.ac.uk>
Date: Fri, 8 Aug 2014 00:11:39 +0100
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <435E586E-2045-4070-8FA7-8DF468280E3C@cam.ac.uk>
To: Al Viro <viro@zeniv.linux.org.uk>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Was just looking at __generic_file_write_iter() and found a bug in the code that you added in 3b93f911d5.

Consider the case where generic_file_direct_write() returns a partial write, i.e. written > 0 && written < count.

Also consider that the following generic_perform_write() fails with an error, i.e. status < 0.

This code then does something very bogus:

		if (unlikely(status < 0) && !written) {
			err = status;
			goto out;
		}
		iocb->ki_pos = pos + status;
		...
		endbyte = pos + status - 1;

The if condition is false as written is > 0 yet status is negative thus iocb->ki_pos is set to pos + status where status is negative thus ki_pos is actually set to "pos - random value".

And similar for "endbyte" being set to "pos - random value - 1", etc.

Doesn't seem like that is what you intended?

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
University of Cambridge Information Services, Roger Needham Building
7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK

