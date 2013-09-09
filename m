Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab3IITKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 15:10:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54200 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab3IITKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 15:10:35 -0400
Date: Mon, 9 Sep 2013 20:10:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Waiman Long <waiman.long@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: Re: [PATCH v4 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
Message-ID: <20130909191028.GT13318@ZenIV.linux.org.uk>
References: <1378743493-33546-1-git-send-email-Waiman.Long@hp.com>
 <1378743493-33546-2-git-send-email-Waiman.Long@hp.com>
 <20130909172905.GN13318@ZenIV.linux.org.uk>
 <CA+55aFx_pUwHg35Ueb4Ewy8ZrBA_UtFbQqdRzL64_Q7iQ=V-rA@mail.gmail.com>
 <20130909180604.GO13318@ZenIV.linux.org.uk>
 <20130909182111.GQ13318@ZenIV.linux.org.uk>
 <20130909183608.GR13318@ZenIV.linux.org.uk>
 <522E17A1.1020205@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522E17A1.1020205@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 02:46:57PM -0400, Waiman Long wrote:

> I am fine with your proposed change as long as it gets the job done.

I suspect that the real problem is the unlock part of read_seqretry_or_unlock();
for d_walk() we want to be able to check if we need retry and continue walking
if we do not.  Let's do it that way: I've applied your patch as is, with the
next step being
	* split read_seqretry_or_unlock():
need_seqretry() (return (!(seq & 1) && read_seqretry(lock, seq))
done_seqretry() (if (seq & 1) write_sequnlock(lock, seq)),
your if (read_seqretry_or_unlock(&rename_lock, &seq))
		goto restart;
becoming
	if (need_seqretry(&rename_lock, seq)) {
		seq = 1;
		goto restart;
	}
	done_seqretry(&rename_lock, seq);

Then d_walk() is trivially massaged to use of read_seqbegin_or_lock(),
need_seqretry() and done_seqretry().  Give me a few, I'll post it...
