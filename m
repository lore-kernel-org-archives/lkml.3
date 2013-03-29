Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab3C2Uet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 16:34:49 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:19187 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756610Ab3C2Ues (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 16:34:48 -0400
Date: Fri, 29 Mar 2013 20:34:43 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Gwendal Grignou <gwendal@google.com>
Cc: linux-kernel@vger.kernel.org, jgarzik@redhat.com
Subject: Re: [PATCH] [libata] Fix HDIO_DRIVE_CMD ioctl sense data check
Message-ID: <20130329203443.GA30494@milliways>
References: <CAMHSBOVZ7w51+8B=LyNBdeqP2BEYaNMDX3_WbEzUYqjdn2FZFg@mail.gmail.com>
 <1364536609-17398-1-git-send-email-gwendal@google.com>
 <20130329183103.GA27693@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130329183103.GA27693@milliways>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Cloudmark-Analysis: v=1.1 cv=GaEGOwq9FwezmTggA+b6yC6zDZF2HYaK6RN/tSqdnVA= c=1 sm=0 a=wom5GMh1gUkA:10 a=7tItc54Vev4A:10 a=uObrxnre4hsA:10 a=8nJEP1OIZ-IA:10 a=f5hi-1-kVf890MI0abgA:9 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 06:31:03PM +0000, Ken Moffat wrote:
> On Thu, Mar 28, 2013 at 10:56:49PM -0700, Gwendal Grignou wrote:
> 
>  Hmm, not sure.  Smartd started and was happy to monitor the disk,
> but I got two new messages between 'found in smartd database' and
> 'is SMART capable. Adding to "monitor" list' -
> 
> Mar 29 17:26:42 ac4tv smartd[2481]: Device: /dev/sda, not capable of
> SMART Health Status check
> Mar 29 17:26:42 ac4tv smartd[2481]: Device: /dev/sda, enable SMART
> Automatic Offline Testing failed.
> 
>  I've seen the first (intermittently) when a drive was starting to
> fail, and apparently there was a taskfile issue in the days of 2.6.22
> which also caused it to appear.  I don't think I've seen the second
> of these before.
> 
>  After going back and forth between the kernel where I reverted your
> original patch, and regular rc4 plus this new patch the output from
> running smartctl as root all seems to be consistent (including
> 'Passed' for the health check).
> 
>  I'm now running with the patch again, and I've started a manual
> 'long' test (which will take 85 minutes, the default 'offline' is
> about 150 minutes).
> 

 Looks like the problem is confined to smartd, smartctl is
different and working fine.  The new messages only come from smartd.cpp :
(sorry, long lines to avoid word wrapping)

  // capability check: SMART status
  if (cfg.smartcheck && ataSmartStatus2(atadev) == -1) {
    PrintOut(LOG_INFO,"Device: %s, not capable of SMART Health Status check\n",name);
    cfg.smartcheck = false;
  }

and

  // enable/disable automatic on-line testing
  if (cfg.autoofflinetest) {
    // is this an enable or disable request?
    const char *what=(cfg.autoofflinetest==1)?"disable":"enable";
    if (!smart_val_ok)
      PrintOut(LOG_INFO,"Device: %s, could not %s SMART Automatic Offline Testing.\n",name, what);
    else {
      // if command appears unsupported, issue a warning...
      if (!isSupportAutomaticTimer(&state.smartval))
        PrintOut(LOG_INFO,"Device: %s, SMART Automatic Offline Testing unsupported...\n",name);
      // ... but then try anyway
      if ((cfg.autoofflinetest==1)?ataDisableAutoOffline(atadev):ataEnableAutoOffline(atadev))
        PrintOut(LOG_INFO,"Device: %s, %s SMART Automatic Offline Testing failed.\n", name, what);
      else
        PrintOut(LOG_INFO,"Device: %s, %sd SMART Automatic Offline Testing.\n", name, what);
    }
  }

 I've no idea about the details, but it looks to me as if smartd is
still getting different values returned to it.  The capability check
normally was ok (silent), the automatic testing normally showed as
'enabled'd.

ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
