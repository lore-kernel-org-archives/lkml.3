Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaCRARL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 20:17:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:53811 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbaCRARJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 20:17:09 -0400
Message-ID: <1395101808.15098.194.camel@pasglop>
Subject: Re: linux-next: build failure after merge of the driver-core tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Mark Brown <broonie@kernel.org>,
        Stewart Smith <stewart@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 18 Mar 2014 11:16:48 +1100
In-Reply-To: <20140317215619.GA25228@kroah.com>
References: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
	 <20140312015021.GC10106@kroah.com>
	 <20140317101611.d043a90e1cb72dcfb8bc767a@canb.auug.org.au>
	 <20140317183333.GE10565@kroah.com> <1395088410.15098.175.camel@pasglop>
	 <20140317215619.GA25228@kroah.com>
Content-Type: multipart/mixed; boundary="=-LW8mq0t8ngvyTxGW5/HS"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LW8mq0t8ngvyTxGW5/HS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Mon, 2014-03-17 at 14:56 -0700, Greg KH wrote:

> No you can't, sorry.
> 
> And this seems like a huge abuse of sysfs, you better be using binary
> sysfs files for your log data...
> 
> Do you have a pointer to where you document this sysfs api in
> Documentation/ABI/ ?

Yes, the patch adds the documentation along with the facility, I've
attached the doc file to this email.

This is a wrapper on top of firmware interfaces, in a way we are
following ACPI precedent of exposing a bunch of things via sysfs, which
also happen to be a simple and very convenient way of doing it.

The log itself is a binary attribute in PEL format (or SEL when we
support that), we have a userspace parser.

> > Now regarding the practicals of sorting out our trees, Stephen suggested
> > that rather than doing anything on my side (heh, I like that !), you
> > should revert the last patch of the series, the one removing the old
> > API, in your tree.
> > 
> > It can then be re-applied later around rc1.
> 
> I'll look to see if we can do that, let me dig it up out of my tree...

Thanks. That's how Stephen is fixing it up in -next at the moment.

Cheers,
Ben.

> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


--=-LW8mq0t8ngvyTxGW5/HS
Content-Disposition: attachment; filename="sysfs-firmware-opal-elog"
Content-Type: text/plain; name="sysfs-firmware-opal-elog"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

What:		/sys/firmware/opal/elog
Date:		Feb 2014
Contact:	Stewart Smith <stewart@linux.vnet.ibm.com>
Description:
		This directory exposes error log entries retrieved
		through the OPAL firmware interface.

		Each error log is identified by a unique ID and will
		exist until explicitly acknowledged to firmware.

		Each log entry has a directory in /sys/firmware/opal/elog.

		Log entries may be purged by the service processor
		before retrieved by firmware or retrieved/acknowledged by
		Linux if there is no room for more log entries.

		In the event that Linux has retrieved the log entries
		but not explicitly acknowledged them to firmware and
		the service processor needs more room for log entries,
		the only remaining copy of a log message may be in
		Linux.

		Typically, a user space daemon will monitor for new
		entries, read them out and acknowledge them.

		The service processor may be able to store more log
		entries than firmware can, so after you acknowledge
		an event from Linux you may instantly get another one
		from the queue that was generated some time in the past.

		The raw log format is a binary format. We currently
		do not parse this at all in kernel, leaving it up to
		user space to solve the problem. In future, we may
		do more parsing in kernel and add more files to make
		it easier for simple user space processes to extract
		more information.

		For each log entry (directory), there are the following
		files:

		id:		An ASCII representation of the ID of the
				error log, in hex - e.g. "0x01".

		type:		An ASCII representation of the type id and
				description of the type of error log.
				Currently just "0x00 PEL" - platform error log.
				In the future there may be additional types.

		raw:		A read-only binary file that can be read
				to get the raw log entry. These are
				<16kb, often just hundreds of bytes and
				"average" 2kb.

		acknowledge:	Writing 'ack' to this file will acknowledge
				the error log to firmware (and in turn
				the service processor, if applicable).
				Shortly after acknowledging it, the log
				entry will be removed from sysfs.
				Reading this file will list the supported
				operations (curently just acknowledge).
--=-LW8mq0t8ngvyTxGW5/HS--

