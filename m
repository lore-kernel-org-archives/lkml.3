Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab3FDC7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 22:59:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab3FDC7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 22:59:30 -0400
Date: Mon, 3 Jun 2013 22:59:08 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Tobias Winter <tobias@linuxdingsda.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] raise the maximum number of usb-serial devices to 512
Message-ID: <20130604025907.GA3991@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
	Tobias Winter <tobias@linuxdingsda.de>,
	=?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
	Rob Landley <rob@landley.net>, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1369721825.2776.36@driftwood>
 <51A327A4.7020908@linuxdingsda.de>
 <87obbwbo8s.fsf@nemi.mork.no>
 <51A332E2.1090403@linuxdingsda.de>
 <20130604024959.GA10697@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130604024959.GA10697@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 07:49:59PM -0700, Greg Kroah-Hartman wrote:
 > On Mon, May 27, 2013 at 02:28:51PM +0200, Bjørn Mork wrote:
 > > But, IMHO, a nicer approach would be to make the allocation completely
 > > dynamic, using e.g. the idr subsystem. Static tables are always feel
 > > like straight jackets to me, no matter how big they are :)
 > 
 > You are right, I didn't change the code to use idr (it predates idr by
 > about a decade or so), because I thought we needed the "rage" logic that
 > the usb-serial minor reservation does.

Rage logic sounds like my kinda code.


 > +static int get_free_port(struct usb_serial_port *port)
 >  {
 > -	unsigned int i, j;
 > -	int good_spot;
 > -
 > -	dev_dbg(&serial->interface->dev, "%s %d\n", __func__, num_ports);
 > +	int i;
 >  
 > -	*minor = 0;
 >  	mutex_lock(&table_lock);
 > -	for (i = 0; i < SERIAL_TTY_MINORS; ++i) {
 > -		if (serial_table[i])
 > -			continue;
 > +	i = idr_alloc(&serial_minors, port, 0, 0, GFP_KERNEL);
 > +	if (i < 0)
 > +		return -EEXIST;
 > +	port->number = i;
 > +	mutex_unlock(&table_lock);
 > +	return i;
 > +}

-EEXIST case misses the mutex unlock.

	Dave

