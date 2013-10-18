Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab3JRCck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 22:32:40 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:30769 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754971Ab3JRCci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 22:32:38 -0400
Date: Thu, 17 Oct 2013 22:32:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH V2 4/5] trace-cmd: Add virt-server mode for a
 virtualization environment
Message-ID: <20131017223237.3acac97d@gandalf.local.home>
In-Reply-To: <20130913020637.28927.43185.stgit@yunodevel>
References: <20130913020627.28927.69090.stgit@yunodevel>
	<20130913020637.28927.43185.stgit@yunodevel>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Sep 2013 11:06:37 +0900
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:

>  static int *create_all_readers(int cpus, const char *node, const char *port,
> -			       int pagesize, int fd)
> +			       const char *domain, int virtpid, int pagesize, int fd)
>  {
>  	char buf[BUFSIZ];
> -	int *port_array;
> +	int *port_array = NULL;
>  	int *pid_array;
>  	int start_port;
>  	int udp_port;
>  	int cpu;
>  	int pid;
>  
> -	port_array = malloc_or_die(sizeof(int) * cpus);
> +	if (node) {
> +		port_array = malloc_or_die(sizeof(int) * cpus);
> +		start_port = START_PORT_SEARCH;
> +	}
>  	pid_array = malloc_or_die(sizeof(int) * cpus);
>  	memset(pid_array, 0, sizeof(int) * cpus);
>  
> -	start_port = START_PORT_SEARCH;
> -
> -	/* Now create a UDP port for each CPU */
> +	/* Now create a reader for each CPU */
>  	for (cpu = 0; cpu < cpus; cpu++) {
> -		udp_port = open_udp(node, port, &pid, cpu,
> -				    pagesize, start_port);
> -		if (udp_port < 0)
> -			goto out_free;
> -		port_array[cpu] = udp_port;
> +		if (node) {
> +			udp_port = open_udp(node, port, &pid, cpu,
> +					    pagesize, start_port);
> +			if (udp_port < 0)
> +				goto out_free;
> +			port_array[cpu] = udp_port;
> +			/*
> +			 * due to some bugging finding ports,

s/due/Due/

> +			 * force search after last port
> +			 */
> +			start_port = udp_port + 1;
> +		} else {
> +			if (open_virtio_serial_pipe(&pid, cpu, pagesize,
> +						    domain, virtpid) < 0)
> +				goto out_free;
> +		}
>  		pid_array[cpu] = pid;
>  		/*
>  		 * Due to some bugging finding ports,

Hmm, it seems that you added the start_port = udp_port + 1 above, but
shouldn't you remove the one here?

> @@ -482,7 +595,7 @@ static int *create_all_readers(int cpus, const char *node, const char *port,
>  	return pid_array;
>  
>   out_free:
> -	destroy_all_readers(cpus, pid_array, node, port);
> +	destroy_all_readers(cpus, pid_array, node, port, domain, virtpid);
>  	return NULL;
>  }
>  
> @@ -524,7 +637,7 @@ static void stop_all_readers(int cpus, int *pid_array)
>  }
>  
>  static void put_together_file(int cpus, int ofd, const char *node,
> -			      const char *port)
> +			      const char *port, const char *domain, int virtpid)
>  {
>  	char **temp_files;
>  	int cpu;
> @@ -533,25 +646,31 @@ static void put_together_file(int cpus, int ofd, const char *node,
>  	temp_files = malloc_or_die(sizeof(*temp_files) * cpus);
>  
>  	for (cpu = 0; cpu < cpus; cpu++)
> -		temp_files[cpu] = get_temp_file(node, port, cpu);
> +		temp_files[cpu] = get_temp_file(node, port, domain,
> +						virtpid, cpu);
>  
>  	tracecmd_attach_cpu_data_fd(ofd, cpus, temp_files);
>  	free(temp_files);
>  }
>  
> -static void process_client(const char *node, const char *port, int fd)
> +static void process_client(const char *node, const char *port,
> +			   const char *domain, int virtpid, int fd)
>  {
>  	int *pid_array;
>  	int pagesize;
>  	int cpus;
>  	int ofd;
>  
> -	if (communicate_with_client(fd, &cpus, &pagesize) < 0)
> -		return;
> -
> -	ofd = create_client_file(node, port);
> +	if (node) {
> +		if (communicate_with_client_nw(fd, &cpus, &pagesize) < 0)

I take it _nw is for "network". If so, please use "*_net" instead. "nw"
is pretty meaningless.

This applies for all functions.

-- Steve

> +			return;
> +	} else {
> +		if (communicate_with_client_virt(fd, domain, &cpus, &pagesize) < 0)
> +			return;
> +	}
>  
> -	pid_array = create_all_readers(cpus, node, port, pagesize, fd);
> +	ofd = create_client_file(node, port, domain, virtpid);
> +	pid_array = create_all_readers(cpus, node, port, domain, virtpid, pagesize, fd);
>  	if (!pid_array)
>  		return;
>  
> @@ -570,9 +689,22 @@ static void process_client(const char *node, const char *port, int fd)
>  	/* wait a little to have the readers clean up */
>  	sleep(1);
>  
> -	put_together_file(cpus, ofd, node, port);
> +	put_together_file(cpus, ofd, node, port, domain, virtpid);
>  
> -	destroy_all_readers(cpus, pid_array, node, port);
> +	destroy_all_readers(cpus, pid_array, node, port, domain, virtpid);
> +}
> +
> +static void process_client_nw(const char *node, const char *port, int fd)
> +{
> +	process_client(node, port, NULL, 0, fd);
> +}
> +
> +static void process_client_virt(const char *domain, int virtpid, int fd)
> +{
> +	/* keep connection to qemu if clients on guests finish operation */
> +	do {
> +		process_client(NULL, NULL, domain, virtpid, fd);
> +	} while (!done);
>  }
>  
>  static int do_fork(int cfd)
> @@ -599,8 +731,8 @@ static int do_fork(int cfd)
>  	return 0;
>  }
>  
> -static int do_connection(int cfd, struct sockaddr_storage *peer_addr,
> -			  socklen_t peer_addr_len)
> +static int do_connection(int cfd, struct sockaddr *peer_addr,
> +			 socklen_t *peer_addr_len, const char *domain, int virtpid)
>  {
>  	char host[NI_MAXHOST], service[NI_MAXSERV];
>  	int s;
> @@ -610,21 +742,22 @@ static int do_connection(int cfd, struct sockaddr_storage *peer_addr,
>  	if (ret)
>  		return ret;
>  
> -	s = getnameinfo((struct sockaddr *)peer_addr, peer_addr_len,
> -			host, NI_MAXHOST,
> -			service, NI_MAXSERV, NI_NUMERICSERV);
> -
> -	if (s == 0)
> -		plog("Connected with %s:%s\n",
> -		       host, service);
> -	else {
> -		plog("Error with getnameinfo: %s\n",
> -		       gai_strerror(s));
> -		close(cfd);
> -		return -1;
> -	}
> -
> -	process_client(host, service, cfd);
> +	if (peer_addr) {
> +		s = getnameinfo(peer_addr, *peer_addr_len, host, NI_MAXHOST,
> +				service, NI_MAXSERV, NI_NUMERICSERV);
> +	
> +		if (s == 0)
> +			plog("Connected with %s:%s\n",
> +			       host, service);
> +		else {
> +			plog("Error with getnameinfo: %s\n",
> +			       gai_strerror(s));
> +			close(cfd);
> +			return -1;
> +		}
> +		process_client_nw(host, service, cfd);
> +	} else
> +		process_client_virt(domain, virtpid, cfd);
>  
>  	close(cfd);
>  
> @@ -634,6 +767,77 @@ static int do_connection(int cfd, struct sockaddr_storage *peer_addr,
>  	return 0;
>  }
>  
> +static int do_connection_nw(int cfd, struct sockaddr *addr, socklen_t *addrlen)
> +{
> +	return do_connection(cfd, addr, addrlen, NULL, 0);
> +}
> +
> +#define LIBVIRT_DOMAIN_PATH     "/var/run/libvirt/qemu/"
> +
> +/* We can convert pid to domain name of a guest when we use libvirt. */
> +static char *get_guest_domain_from_pid(int pid)
> +{
> +	struct dirent *dirent;
> +	char file_name[NAME_MAX];
> +	char *file_name_ret, *domain;
> +	char buf[BUFSIZ];
> +	DIR *dir;
> +	size_t doml;
> +	int fd;
> +
> +	dir = opendir(LIBVIRT_DOMAIN_PATH);
> +	if (!dir) {
> +		if (errno == ENOENT)
> +			warning("Only support for using libvirt");
> +		return NULL;
> +	}
> +
> +	for (dirent = readdir(dir); dirent != NULL; dirent = readdir(dir)) {
> +		snprintf(file_name, NAME_MAX, LIBVIRT_DOMAIN_PATH"%s",
> +			 dirent->d_name);
> +		file_name_ret = strstr(file_name, ".pid");
> +		if (file_name_ret) {
> +			fd = open(file_name, O_RDONLY);
> +			if (fd < 0)
> +				return NULL;
> +			if (read(fd, buf, BUFSIZ) < 0)
> +				return NULL;
> +
> +			if (pid == atoi(buf)) {
> +				/* not include /var/run/libvirt/qemu */
> +				doml = (size_t)(file_name_ret - file_name)
> +					- strlen(LIBVIRT_DOMAIN_PATH);
> +				domain = strndup(file_name +
> +						 strlen(LIBVIRT_DOMAIN_PATH),
> +						 doml);
> +				plog("start %s:%d\n", domain, pid);
> +				return domain;
> +			}
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
> +static int do_connection_virt(int cfd)
> +{
> +	struct ucred cr;
> +	socklen_t cl;
> +	int ret;
> +	char *domain;
> +
> +	cl = sizeof(cr);
> +	ret = getsockopt(cfd, SOL_SOCKET, SO_PEERCRED, &cr, &cl);
> +	if (ret < 0)
> +		return ret;
> +
> +	domain = get_guest_domain_from_pid(cr.pid);
> +	if (!domain)
> +		return -1;
> +
> +	return do_connection(cfd, NULL, NULL, domain, cr.pid);
> +}
> +
>  static int *client_pids;
>  static int saved_pids;
>  static int size_pids;
> @@ -678,12 +882,11 @@ static void remove_process(int pid)
>  
>  static void kill_clients(void)
>  {
> -	int status;
>  	int i;
>  
>  	for (i = 0; i < saved_pids; i++) {
>  		kill(client_pids[i], SIGINT);
> -		waitpid(client_pids[i], &status, 0);
> +		waitpid(client_pids[i], NULL, 0);
>  	}
>  
>  	saved_pids = 0;
> @@ -702,31 +905,51 @@ static void clean_up(int sig)
>  	} while (ret > 0);
>  }
>  
> -static void do_accept_loop(int sfd)
> +static void do_accept_loop(int sfd, bool nw, struct sockaddr *addr,
> +			   socklen_t *addrlen)
>  {
> -	struct sockaddr_storage peer_addr;
> -	socklen_t peer_addr_len;
>  	int cfd, pid;
>  
> -	peer_addr_len = sizeof(peer_addr);
> -
>  	do {
> -		cfd = accept(sfd, (struct sockaddr *)&peer_addr,
> -			     &peer_addr_len);
> +		cfd = accept(sfd, addr, addrlen);
>  		printf("connected!\n");
>  		if (cfd < 0 && errno == EINTR)
>  			continue;
>  		if (cfd < 0)
>  			pdie("connecting");
>  
> -		pid = do_connection(cfd, &peer_addr, peer_addr_len);
> +		if (nw)
> +			pid = do_connection_nw(cfd, addr, addrlen);
> +		else
> +			pid = do_connection_virt(cfd);
>  		if (pid > 0)
>  			add_process(pid);
>  
>  	} while (!done);
>  }
>  
> -static void do_listen(char *port)
> +static void do_accept_loop_nw(int sfd)
> +{
> +	struct sockaddr_storage peer_addr;
> +	socklen_t peer_addr_len;
> +
> +	peer_addr_len = sizeof(peer_addr);
> +
> +	do_accept_loop(sfd, true, (struct sockaddr *)&peer_addr,
> +		       &peer_addr_len);
> +}
> +
> +static void do_accept_loop_virt(int sfd)
> +{
> +	struct sockaddr_un un_addr;
> +	socklen_t un_addrlen;
> +
> +	un_addrlen = sizeof(un_addr);
> +
> +	do_accept_loop(sfd, false, (struct sockaddr *)&un_addr, &un_addrlen);
> +}
> +
> +static void do_listen_nw(char *port)
>  {
>  	struct addrinfo hints;
>  	struct addrinfo *result, *rp;
> @@ -764,11 +987,67 @@ static void do_listen(char *port)
>  	if (listen(sfd, backlog) < 0)
>  		pdie("listen");
>  
> -	do_accept_loop(sfd);
> +	do_accept_loop_nw(sfd);
>  
>  	kill_clients();
>  }
>  
> +static void make_virt_if_dir(void)
> +{
> +	struct group *group;
> +
> +	if (mkdir(TRACE_CMD_DIR, 0710) < 0) {
> +		if (errno != EEXIST)
> +			pdie("mkdir %s", TRACE_CMD_DIR);
> +	}
> +	/* QEMU operates as qemu:qemu */
> +	chmod(TRACE_CMD_DIR, 0710);
> +	group = getgrnam("qemu");
> +	if (chown(TRACE_CMD_DIR, -1, group->gr_gid) < 0)
> +		pdie("chown %s", TRACE_CMD_DIR);
> +
> +	if (mkdir(VIRT_DIR, 0710) < 0) {
> +		if (errno != EEXIST)
> +			pdie("mkdir %s", VIRT_DIR);
> +	}
> +	chmod(VIRT_DIR, 0710);
> +	if (chown(VIRT_DIR, -1, group->gr_gid) < 0)
> +		pdie("chown %s", VIRT_DIR);
> +}
> +
> +static void do_listen_virt(void)
> +{
> +	struct sockaddr_un un_server;
> +	struct group *group;
> +	socklen_t slen;
> +	int sfd;
> +
> +	make_virt_if_dir();
> +
> +	slen = sizeof(un_server);
> +	sfd = socket(AF_UNIX, SOCK_STREAM, 0);
> +	if (sfd < 0)
> +		pdie("socket");
> +
> +	un_server.sun_family = AF_UNIX;
> +	snprintf(un_server.sun_path, PATH_MAX, VIRT_TRACE_CTL_SOCK);
> +
> +	if (bind(sfd, (struct sockaddr *)&un_server, slen) < 0)
> +		pdie("bind");
> +	chmod(VIRT_TRACE_CTL_SOCK, 0660);
> +	group = getgrnam("qemu");
> +	if (chown(VIRT_TRACE_CTL_SOCK, -1, group->gr_gid) < 0)
> +		pdie("fchown %s", VIRT_TRACE_CTL_SOCK);
> +
> +	if (listen(sfd, backlog) < 0)
> +		pdie("listen");
> +
> +	do_accept_loop_virt(sfd);
> +
> +	unlink(VIRT_TRACE_CTL_SOCK);
> +	kill_clients();
> +}
> +
>  static void start_daemon(void)
>  {
>  	if (daemon(1, 0) < 0)
> @@ -785,11 +1064,17 @@ void trace_listen(int argc, char **argv)
>  	char *port = NULL;
>  	int daemon = 0;
>  	int c;
> +	int nw = 0;
> +	int virt = 0;
>  
>  	if (argc < 2)
>  		usage(argv);
>  
> -	if (strcmp(argv[1], "listen") != 0)
> +	if ((nw = (strcmp(argv[1], "listen") == 0)))
> +		; /* do nothing */
> +	else if ((virt = (strcmp(argv[1], "virt-server") == 0)))
> +		; /* do nothing */
> +	else
>  		usage(argv);
>  
>  	for (;;) {
> @@ -810,6 +1095,8 @@ void trace_listen(int argc, char **argv)
>  			usage(argv);
>  			break;
>  		case 'p':
> +			if (virt)
> +				die("-p only available with listen");
>  			port = optarg;
>  			break;
>  		case 'd':
> @@ -832,7 +1119,7 @@ void trace_listen(int argc, char **argv)
>  		}
>  	}
>  
> -	if (!port)
> +	if (!port && nw)
>  		usage(argv);
>  
>  	if ((argc - optind) >= 2)
> @@ -860,7 +1147,10 @@ void trace_listen(int argc, char **argv)
>  	signal_setup(SIGINT, finish);
>  	signal_setup(SIGTERM, finish);
>  
> -	do_listen(port);
> +	if (nw)
> +		do_listen_nw(port);
> +	else
> +		do_listen_virt();
>  
>  	return;
>  }
> diff --git a/trace-msg.c b/trace-msg.c
> index 61bde54..0b3b356 100644
> --- a/trace-msg.c
> +++ b/trace-msg.c
> @@ -59,6 +59,11 @@ typedef __be32 be32;
>  
>  #define CPU_MAX				256
>  
> +/* use CONNECTION_MSG as a protocol version of trace-msg */
> +#define MSG_VERSION		"V2"
> +#define CONNECTION_MSG		"tracecmd-" MSG_VERSION
> +#define CONNECTION_MSGSIZE	sizeof(CONNECTION_MSG)
> +
>  /* for both client and server */
>  bool use_tcp;
>  int cpu_count;
> @@ -78,6 +83,10 @@ struct tracecmd_msg_str {
>  	char *buf;
>  } __attribute__((packed));
>  
> +struct tracecmd_msg_rconnect {
> +	struct tracecmd_msg_str str;
> +};
> +
>  struct tracecmd_msg_opt {
>  	be32 size;
>  	be32 opt_cmd;
> @@ -104,6 +113,7 @@ struct tracecmd_msg_error {
>  	be32 size;
>  	be32 cmd;
>  	union {
> +		struct tracecmd_msg_rconnect rconnect;
>  		struct tracecmd_msg_tinit tinit;
>  		struct tracecmd_msg_rinit rinit;
>  		struct tracecmd_msg_meta meta;
> @@ -111,7 +121,10 @@ struct tracecmd_msg_error {
>  } __attribute__((packed));
>  
>  enum tracecmd_msg_cmd {
> +	MSG_ERROR	= 0,
>  	MSG_CLOSE	= 1,
> +	MSG_TCONNECT	= 2,
> +	MSG_RCONNECT	= 3,
>  	MSG_TINIT	= 4,
>  	MSG_RINIT	= 5,
>  	MSG_SENDMETA	= 6,
> @@ -122,6 +135,7 @@ struct tracecmd_msg {
>  	be32 size;
>  	be32 cmd;
>  	union {
> +		struct tracecmd_msg_rconnect rconnect;
>  		struct tracecmd_msg_tinit tinit;
>  		struct tracecmd_msg_rinit rinit;
>  		struct tracecmd_msg_meta meta;
> @@ -155,6 +169,16 @@ static void bufcpy(void *dest, u32 offset, const void *buf, u32 buflen)
>  	memcpy(dest+offset, buf, buflen);
>  }
>  
> +static int make_rconnect(const char *buf, int buflen, struct tracecmd_msg *msg)
> +{
> +	u32 offset = offsetof(struct tracecmd_msg, data.rconnect.str.buf);
> +
> +	msg->data.rconnect.str.size = htonl(buflen);
> +	bufcpy(msg, offset, buf, buflen);
> +
> +	return 0;
> +}
> +
>  enum msg_opt_command {
>  	MSGOPT_USETCP = 1,
>  };
> @@ -232,11 +256,13 @@ static int make_rinit(struct tracecmd_msg *msg)
>  
>  	msg->data.rinit.cpus = htonl(cpu_count);
>  
> -	for (i = 0; i < cpu_count; i++) {
> -		/* + rrqports->cpus or rrqports->port_array[i] */
> -		offset += sizeof(be32);
> -		port = htonl(port_array[i]);
> -		bufcpy(msg, offset, &port, sizeof(be32) * cpu_count);
> +	if (port_array) {
> +		for (i = 0; i < cpu_count; i++) {
> +			/* + rrqports->cpus or rrqports->port_array[i] */
> +			offset += sizeof(be32);
> +			port = htonl(port_array[i]);
> +			bufcpy(msg, offset, &port, sizeof(be32) * cpu_count);
> +		}
>  	}
>  
>  	return 0;
> @@ -248,6 +274,8 @@ static u32 tracecmd_msg_get_body_length(u32 cmd)
>  	u32 len = 0;
>  
>  	switch (cmd) {
> +	case MSG_RCONNECT:
> +		return sizeof(msg->data.rconnect.str.size) + CONNECTION_MSGSIZE;
>  	case MSG_TINIT:
>  		len = sizeof(msg->data.tinit.cpus)
>  		      + sizeof(msg->data.tinit.page_size)
> @@ -285,6 +313,8 @@ static u32 tracecmd_msg_get_body_length(u32 cmd)
>  static int tracecmd_msg_make_body(u32 cmd, u32 len, struct tracecmd_msg *msg)
>  {
>  	switch (cmd) {
> +	case MSG_RCONNECT:
> +		return make_rconnect(CONNECTION_MSG, CONNECTION_MSGSIZE, msg);
>  	case MSG_TINIT:
>  		return make_tinit(len, msg);
>  	case MSG_RINIT:
> @@ -425,6 +455,8 @@ static void *tracecmd_msg_buf_access(struct tracecmd_msg *msg, int offset)
>  static int tracecmd_msg_wait_for_msg(int fd, struct tracecmd_msg **msg)
>  {
>  	char msg_tmp[TRACECMD_MSG_MAX_LEN];
> +	char *buf;
> +	int offset = TRACECMD_MSG_HDR_LEN;
>  	u32 cmd;
>  	int ret;
>  
> @@ -437,8 +469,20 @@ static int tracecmd_msg_wait_for_msg(int fd, struct tracecmd_msg **msg)
>  
>  	*msg = (struct tracecmd_msg *)msg_tmp;
>  	cmd = ntohl((*msg)->cmd);
> -	if (cmd == MSG_CLOSE)
> +	switch (cmd) {
> +	case MSG_RCONNECT:
> +		offset += sizeof((*msg)->data.rconnect.str.size);
> +		buf = tracecmd_msg_buf_access(*msg, offset);
> +		/* Make sure the server is the tracecmd server */
> +		if (memcmp(buf, CONNECTION_MSG,
> +		    ntohl((*msg)->data.rconnect.str.size) - 1) != 0) {
> +			warning("server not tracecmd server");
> +			return -EPROTONOSUPPORT;
> +		}
> +		break;
> +	case MSG_CLOSE:
>  		return -ECONNABORTED;
> +	}
>  
>  	return 0;
>  }
> @@ -495,7 +539,54 @@ static void error_operation_for_server(struct tracecmd_msg *msg)
>  
>  	cmd = ntohl(msg->cmd);
>  
> -	warning("Message: cmd=%d size=%d\n", cmd, ntohl(msg->size));
> +	if (cmd == MSG_ERROR)
> +		plog("Receive error message: cmd=%d size=%d\n",
> +		     ntohl(msg->data.err.cmd), ntohl(msg->data.err.size));
> +	else
> +		warning("Message: cmd=%d size=%d\n", cmd, ntohl(msg->size));
> +}
> +
> +int tracecmd_msg_set_connection(int fd, const char *domain)
> +{
> +	struct tracecmd_msg *msg;
> +	char buf[TRACECMD_MSG_MAX_LEN] = {};
> +	u32 cmd;
> +	int ret;
> +
> +	/*
> +	 * Wait for connection msg by a client first.
> +	 * If a client uses virtio-serial, a connection message will
> +	 * not be sent immediately after accept(). connect() is called
> +	 * in QEMU, so the client can send the connection message
> +	 * after guest boots. Therefore, the virt-server patiently
> +	 * waits for the connection request of a client.
> +	 */ 
> +	ret = tracecmd_msg_recv(fd, buf);
> +	if (ret < 0) {
> +		if (!buf[0]) {
> +			/* No data means QEMU has already died. */
> +			close(fd);
> +			die("Connection refuesd: %s", domain);
> +		}
> +		return -ENOMSG;
> +	}
> +
> +	msg = (struct tracecmd_msg *)buf;
> +	cmd = ntohl(msg->cmd);
> +	if (cmd == MSG_CLOSE)
> +		return -ECONNABORTED;
> +	else if (cmd != MSG_TCONNECT)
> +		return -EINVAL;
> +
> +	ret = tracecmd_msg_send(fd, MSG_RCONNECT);
> +	if (ret < 0)
> +		goto error;
> +
> +	return 0;
> +
> +error:
> +	error_operation_for_server(msg);
> +	return ret;
>  }
>  
>  #define MAX_OPTION_SIZE 4096
> diff --git a/trace-recorder.c b/trace-recorder.c
> index 520d486..8169dc3 100644
> --- a/trace-recorder.c
> +++ b/trace-recorder.c
> @@ -149,19 +149,23 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
>  	recorder->fd1 = fd;
>  	recorder->fd2 = fd2;
>  
> -	path = malloc_or_die(strlen(buffer) + 40);
> -	if (!path)
> -		goto out_free;
> -
> -	if (flags & TRACECMD_RECORD_SNAPSHOT)
> -		sprintf(path, "%s/per_cpu/cpu%d/snapshot_raw", buffer, cpu);
> -	else
> -		sprintf(path, "%s/per_cpu/cpu%d/trace_pipe_raw", buffer, cpu);
> -	recorder->trace_fd = open(path, O_RDONLY);
> -	if (recorder->trace_fd < 0)
> -		goto out_free;
> -
> -	free(path);
> +	if (buffer) {
> +		path = malloc_or_die(strlen(buffer) + 40);
> +		if (!path)
> +			goto out_free;
> +	
> +		if (flags & TRACECMD_RECORD_SNAPSHOT)
> +			sprintf(path, "%s/per_cpu/cpu%d/snapshot_raw",
> +				buffer, cpu);
> +		else
> +			sprintf(path, "%s/per_cpu/cpu%d/trace_pipe_raw",
> +				buffer, cpu);
> +		recorder->trace_fd = open(path, O_RDONLY);
> +		if (recorder->trace_fd < 0)
> +			goto out_free;
> +	
> +		free(path);
> +	}
>  
>  	if ((recorder->flags & TRACECMD_RECORD_NOSPLICE) == 0) {
>  		ret = pipe(recorder->brass);
> @@ -184,8 +188,9 @@ tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, const char *
>  	return tracecmd_create_buffer_recorder_fd2(fd, -1, cpu, flags, buffer, 0);
>  }
>  
> -struct tracecmd_recorder *
> -tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags, const char *buffer)
> +static struct tracecmd_recorder *
> +__tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
> +				  const char *buffer)
>  {
>  	struct tracecmd_recorder *recorder;
>  	int fd;
> @@ -248,6 +253,25 @@ tracecmd_create_buffer_recorder_maxkb(const char *file, int cpu, unsigned flags,
>  	goto out;
>  }
>  
> +struct tracecmd_recorder *
> +tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
> +				const char *buffer)
> +{
> +	return __tracecmd_create_buffer_recorder(file, cpu, flags, buffer);
> +}
> +
> +struct tracecmd_recorder *
> +tracecmd_create_recorder_virt(const char *file, int cpu, int trace_fd)
> +{
> +	struct tracecmd_recorder *recorder;
> +
> +	recorder = __tracecmd_create_buffer_recorder(file, cpu, 0, NULL);
> +	if (recorder)
> +		recorder->trace_fd = trace_fd;
> +
> +	return recorder;
> +}
> +
>  struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu, unsigned flags)
>  {
>  	char *tracing;
> diff --git a/trace-usage.c b/trace-usage.c
> index b8f26e6..e6a239f 100644
> --- a/trace-usage.c
> +++ b/trace-usage.c
> @@ -153,6 +153,16 @@ static struct usage_help usage_help[] = {
>  		"	   -l logfile to write messages to.\n"
>  	},
>  	{
> +		"virt-server",
> +		"listen on a virtio-serial for trace clients",
> +		" %s virt-server [-o file][-d dir][-l logfile]\n"
> +		"          Creates a socket to listen for clients.\n"
> +		"          -D create it in daemon mode.\n"
> +		"          -o file name to use for clients.\n"
> +		"          -d diretory to store client files.\n"
> +		"	   -l logfile to write messages to.\n"
> +	},
> +	{
>  		"list",
>  		"list the available events, plugins or options",
>  		" %s list [-e][-t][-o][-f [regex]]\n"

