Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab3K0A6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:58:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab3K0A6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 3.12 027/116] staging: comedi: avoid memleak for subdevice private
Date: Tue, 26 Nov 2013 16:56:40 -0800
Message-Id: <20131127005738.820326565@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 67aa4acbc97f6a55b328e4e2305ef19cbe949d85 upstream.

`comedi_alloc_spriv()` allocates private storage for a comedi subdevice
and sets the `SRF_FREE_SPRIV` flag in the `runflags` member of the
subdevice to allow the private storage to be automatically freed when
the comedi device is being cleaned up.  Unfortunately, the flag gets
clobbered by `do_cmd_ioctl()` which calls
`comedi_set_subdevice_runflags()` with a mask value `~0` and only the
`SRF_USER` and `SRF_RUNNING` flags set, all the other SRF flags being
cleared.

Change the calls to `comedi_set_subdevice_runflags()` that currently use
a mask value of `~0` to use a more relevant mask value.  For
`do_cmd_ioctl()`, the relevant SRF flags are `SRF_USER`, `SRF_ERROR` and
`SRF_RUNNING`.  (At one time, `SRF_RT` would be included in that set of
flags, but it is no longer used.)  For `comedi_alloc_spriv()` replace
the call to `comedi_set_subdevice_runflags()` with a simple
OR-assignment to avoid unnecessary use of a spin-lock.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/comedi_fops.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -543,7 +543,7 @@ void *comedi_alloc_spriv(struct comedi_s
 {
 	s->private = kzalloc(size, GFP_KERNEL);
 	if (s->private)
-		comedi_set_subdevice_runflags(s, ~0, SRF_FREE_SPRIV);
+		s->runflags |= SRF_FREE_SPRIV;
 	return s->private;
 }
 EXPORT_SYMBOL_GPL(comedi_alloc_spriv);
@@ -1485,7 +1485,8 @@ static int do_cmd_ioctl(struct comedi_de
 	if (async->cmd.flags & TRIG_WAKE_EOS)
 		async->cb_mask |= COMEDI_CB_EOS;
 
-	comedi_set_subdevice_runflags(s, ~0, SRF_USER | SRF_RUNNING);
+	comedi_set_subdevice_runflags(s, SRF_USER | SRF_ERROR | SRF_RUNNING,
+				      SRF_USER | SRF_RUNNING);
 
 	/* set s->busy _after_ setting SRF_RUNNING flag to avoid race with
 	 * comedi_read() or comedi_write() */


