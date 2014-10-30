Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161207AbaJ3Uaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 16:30:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513AbaJ3Ua3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 16:30:29 -0400
Date: Thu, 30 Oct 2014 13:29:18 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: comedi: comedi_test: fix timer lock-up
Message-ID: <20141030202918.GA27910@kroah.com>
References: <1414501642-14261-1-git-send-email-abbotti@mev.co.uk>
 <1414663433-11137-1-git-send-email-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414663433-11137-1-git-send-email-abbotti@mev.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 10:03:53AM +0000, Ian Abbott wrote:
> Commit 240512474424 ("staging: comedi: comedi_test: use
> comedi_handle_events()") resulted in the timer routine
> `waveform_ai_interrupt()` calling `comedi_handle_events()` instead of
> `comedi_events()`.  That had the advantage of automatically stopping the
> acquisition on overflow/error/end-of-acquisition conditions (by calling
> the comedi subdevice's "cancel" handler), but currently results in the
> timer routine locking when one of those conditions occur.  This is
> because the "cancel" handler `waveform_ai_cancel()` calls
> `del_timer_sync()`.
> 
> Fix it by adding a bit to the device private data that indicates whether
> the acquisition is active or not, and changing the "cancel" handler to
> use `del_timer()` instead of `del_timer_sync()`.  The bit is set when
> starting the acquisition, cleared when ending the acquisition (in the
> "cancel" handler), and tested in the timer routine, which will do
> nothing if the acquisition is inactive.  Also, make sure any scheduled
> timeout event gets cancelled when the low-level device gets "detached"
> from the comedi core by calling `del_timer_sync()` in the "detach"
> handler `waveform_detach()`.
> 
> Fixes: 240512474424 ("staging: comedi: comedi_test: use comedi_handle_events()")
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
> v2: rebased after commit dd28153b2a8ca
> Greg, this fix is for "linux-next" and "staging-next".

I don't understand, I've already taken this patch, right?  It doesn't
apply to my branch :(

confused,

greg k-h
